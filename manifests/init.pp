class local-openstack {
  

  Apt::Source['folsom_trunk_testing'] ->
  Package['git'] ->
# Apt::Source['ubuntu_cloud_archive'] -> 
  Package['apache2'] ->
  Service['apache2'] # -> Class['openstack::all']

  package { 'python-software-properties':
    ensure            => 'latest',
  }
  apt::source { 'ubuntu_cloud_archive':
    location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
    release           => 'precise-updates/folsom',
    repos             => 'main',
    key               => 'EC4926EA',
    key_server        => 'subkeys.pgp.net',
    pin               => '-10',
    include_src       => true
  } 
  apt::source { 'folsom_trunk_testing':
    location          => 'http://ppa.launchpad.net/openstack-ubuntu-testing/folsom-trunk-testing/ubuntu',
    release           => 'precise',
    repos             => 'main',
    key               => '3B6F61A6',
    key_server        => 'subkeys.pgp.net',
    pin               => '-10',
    include_src       => true
  } 
  package { 'apache2':
    ensure               => 'latest',
  } 
  service { 'apache2':
    ensure               => 'running',
    subscribe            => Package['apache2'],
  } 
# class { 'openstack::all':
#   public_address       => '192.168.1.12',
#   public_interface     => 'eth0',
#   private_interface    => 'eth1',
#   admin_email          => 'some_admin@some_company',
#   admin_password       => 'admin_password',
#   nova_db_password     => 'password',
#   glance_db_password   => 'password',
#   keystone_db_password => 'password',
#   secret_key           => 'password',
#   mysql_root_password  => 'password',
#   quantum              => false,
#   keystone_admin_token => 'keystone_admin_token',
#   nova_user_password   => 'nova_user_password',
#   glance_user_password => 'glance_user_password',
#   rabbit_password      => 'rabbit_password',
#   rabbit_user          => 'rabbit_user',
#   libvirt_type         => 'kvm',
#   fixed_range          => '10.0.2.0/24',
# }
  package { 'git':
    ensure            => 'latest',
  }
}

