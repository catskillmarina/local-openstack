class local-openstack {
  

# Apt::Source['folsom_trunk_testing'] ->

  Package['python-software-properties'] ->
# Package['bridge-utils'] ->
  Package['git'] ->
  Package['lynx'] ->
  Package['ubuntu-cloud-keyring'] ->
  File['/etc/apt/sources.list'] ->
  Exec['apt-get update'] ->
  Exec['brctl addbr br100'] ->
  Exec['ifconfig br100 192.168.100.1'] # ->
  File['/etc/apache2/mods-available/wsgi.conf'] ~>
  Package['apache2'] ->
# Apt::Source['ubuntu_cloud_archive'] ->
  Service['apache2']   -> 
  Class['openstack::all']

  package { 'ntfs-3g':
    ensure            => 'absent',
  }
  package { 'python-software-properties':
    ensure            => 'latest',
  }
# package { 'bridge-utils':
#   ensure            => 'latest',
# }
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
  exec { 'brctl addbr br100':
    path              => '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin',
    onlyif            => "ifconfig -a |grep br100| wc -l |grep 0 > /dev/null",
    subscribe         => Package['bridge-utils'],
  }
  exec { 'ifconfig br100 192.168.100.1':
    path              => '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin',
    onlyif            => 'ifconfig br100|grep 192.168.100.1|wc -l|grep 0 > /dev/null',
    subscribe         => Exec['brctl addbr br100'],
    alias             => 'ifconfig-bridge',
  }

# apt::source { 'ubuntu_cloud_archive':
#   location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
#   release           => 'precise-updates/folsom',
#   repos             => 'main',
#   key               => 'EC4926EA',
#   key_server        => 'subkeys.pgp.net',
#   pin               => '-10',
#   include_src       => true
# } 
# apt::source { 'folsom_trunk_testing':
#   location          => 'http://ppa.launchpad.net/openstack-ubuntu-testing/folsom-trunk-testing/ubuntu',
#   release           => 'precise',
#   repos             => 'main',
#   key               => '3B6F61A6',
#   key_server        => 'subkeys.pgp.net',
#   pin               => '-10',
#   include_src       => true
# } 
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
    private_interface    => 'br100',
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
  }
  file { '/etc/apache2/mods-available/wsgi.conf':
    ensure               => 'file',
    owner                => 'root',
    mode                 => '0644',
    source               => 'puppet:///modules/local-openstack/wsgi.conf',
  }
}

