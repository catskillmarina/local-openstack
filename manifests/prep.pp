class local-openstack::prep {

  Apt::Key['ubuntu_cloud_archive'] ->
  Apt::Source['ubuntu_cloud_archive'] ->
  Exec['apt-get update'] ->
  Package['python-software-properties'] ->
  Package['git'] ->
  Package['lynx'] ->
  Package['apache2'] ->
  Service['apache2']

  apt::key { 'ubuntu_cloud_archive':
    key        => 'EC4926EA',
    key_server => 'keyserver.ubuntu.com',
  }
  apt::source { 'ubuntu_cloud_archive':
    location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
    release           => 'precise-updates/folsom',
    repos             => 'main',
    key               => 'EC4926EA',
    key_server        => 'keyserver.ubuntu.com',
    include_src       => true
  }
  package { 'ntfs-3g':
    ensure            => 'absent',
  }
  package { 'python-software-properties':
    ensure            => 'latest',
  }
  package { 'git':
    ensure            => 'latest',
  }
  package { 'lynx':
    ensure            => 'latest',
  }
# package { 'ubuntu-cloud-keyring':
#   ensure            => 'latest',
# }
# file { '/etc/apt/sources.list':
#   ensure            => 'file',
#   source            => 'puppet:///modules/local-openstack/sources.list',
#   owner             => 'root',
#   mode              => '0644',
# }
  exec {'apt-get update':
    path              => '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin',
#   subscribe         => File['/etc/apt/sources.list'],
    refreshonly       => true,
  }
  package { 'apache2':
    ensure               => 'latest',
  }
  service { 'apache2':
    ensure               => 'running',
    subscribe            => Package['apache2'],
  }
}

