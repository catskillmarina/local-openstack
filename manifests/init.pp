class local-openstack {

  File['/etc/apt/sources.list'] ->
  Exec['apt-get update'] ->
  Package['python-software-properties'] ->
  Package['git'] ->
  Package['lynx'] ->
  Package['ubuntu-cloud-keyring'] ->
  File['/etc/apache2/'] ->
  File['/etc/apache2/mods-available/'] ->
  File['/etc/apache2/mods-available/wsgi.conf'] ->
  Package['apache2'] ->
  Service['apache2']   -> 
  Class['openstack::all']

  package { 'ntfs-3g':
    ensure            => 'absent',
  }
  package { 'python-software-properties':
    ensure            => 'latest',
  }
  file { '/etc/apache2/':
    ensure               => 'directory',
    owner                => 'root',
    mode                 => '0755',
  }
  file { '/etc/apache2/mods-available/':
    ensure               => 'directory',
    owner                => 'root',
    mode                 => '0755',
  }
  file { '/etc/apache2/mods-available/wsgi.conf':
    ensure               => 'file',
    owner                => 'root',
    mode                 => '0644',
    source               => 'puppet:///modules/local-openstack/wsgi.conf',
  }
  package { 'git':
    ensure            => 'latest',
  }
  package { 'lynx':
    ensure            => 'latest',
  }
  package { 'ubuntu-cloud-keyring':
    ensure            => 'latest',
  }
  file { '/etc/apt/sources.list':
    ensure            => 'file',
    source            => 'puppet:///modules/local-openstack/sources.list',
    owner             => 'root',
    mode              => '0644',
  }
  exec {'apt-get update':
    path              => '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin',
    subscribe         => File['/etc/apt/sources.list'],
    refreshonly       => true,
  }
  package { 'apache2':
    ensure               => 'latest',
  } 
  service { 'apache2':
    ensure               => 'running',
    subscribe            => Package['apache2'],
  } 
  class { 'openstack::all':
    public_address       => '10.0.2.15',
    public_interface     => 'eth0',
    private_interface    => 'eth1',
    admin_email          => 'some_admin@some_company',
    admin_password       => 'admin_password',
    nova_db_password     => 'password',
    glance_db_password   => 'password',
    keystone_db_password => 'password',
    secret_key           => 'password',
    mysql_root_password  => 'password',
    quantum              => false,
    keystone_admin_token => 'keystone_admin_token',
    nova_user_password   => 'nova_user_password',
    glance_user_password => 'glance_user_password',
    rabbit_password      => 'rabbit_password',
    rabbit_user          => 'rabbit_user',
#   libvirt_type         => 'kvm',
    libvirt_type         => 'qemu',
    fixed_range          => '192.168.100.0/24',
#   multi_host           => true,
    purge_nova_config    => false,
  }
  class { 'openstack::auth_file':
    admin_user           => 'admin',
    admin_tenant         => 'admin',
    controller_node      => '127.0.0.1',
    admin_password       => 'admin_password',
    keystone_admin_token => 'keystone_admin_token',
  }
  file { '/usr/local/admin':
    ensure               => 'directory',
    mode                 => '0755',
  }
  file { '/usr/local/admin/bin':
    ensure               => 'directory',
    mode                 => '0755',
    subscribe            => File['/usr/local/admin'],
  }
  file { '/usr/local/admin/bin/glance_add_image.sh':
    ensure               => 'file',
    mode                 => '0755',
    subscribe            => File['/usr/local/admin/bin'],
    content              => '#!/bin/sh

url=$1
diskname=$2
format=$3
container_format=$4

. /root/openrc

wget -c ${url} -O /var/spool/stackimages/${diskname}
glance add name=${diskname} disk_format=${format} container_format=${container_format} < /var/spool/stackimages/${diskname}

'
  }
  file { '/usr/local/admin/bin/glance_list_images.sh':
    ensure               => 'file',
    mode                 => '0755',
    subscribe            => File['/usr/local/admin/bin'],
    content              => '#!/bin/sh

. /root/openrc

glance index 

'
  }
  file { '/var/spool/stackimages':
    ensure               => 'directory',
    mode                 => '0755',
  }
}

