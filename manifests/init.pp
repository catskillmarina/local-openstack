class local-openstack {

  Class['local-openstack::prep'] ->
  File['/etc/apache2/'] ->
  File['/etc/apache2/mods-available/'] ->
  File['/etc/apache2/mods-available/wsgi.conf'] ->
  Class['openstack::all']

  class { 'local-openstack::prep': }
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
    source               => 'puppet:///modules/local-openstack/glance_add_image.sh',
  }
  file { '/usr/local/admin/bin/glance_list_images.sh':
    ensure               => 'file',
    mode                 => '0755',
    subscribe            => File['/usr/local/admin/bin'],
    source               => 'puppet:///modules/local-openstack/glance_list_images.sh',
  }
  file { '/var/spool/stackimages':
    ensure               => 'directory',
    mode                 => '0755',
  }
  exec { '/usr/local/admin/bin/glance_add_image.sh https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img  cirros-0.3.0-x86_64-disk.img qcow2 bare':
    onlyif               => '/usr/local/admin/bin/glance_list_images.sh |grep cirros-0.3.0-x86_64-disk.img |wc -l |grep 0',
    subscribe            => File['/var/spool/stackimages'],
  }
  exec { '/usr/local/admin/bin/glance_add_image.sh http://uec-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img  precise-server-cloudimg-amd64-disk1.img qcow2 bare':
    onlyif               => '/usr/local/admin/bin/glance_list_images.sh |grep precise-server-cloudimg-amd64-disk1.img |wc -l |grep 0',
    subscribe            => File['/var/spool/stackimages'],
  }
}

