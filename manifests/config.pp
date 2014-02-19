# == Class: solr::config
# This class sets up solr install
#
# === Parameters
# - The $cores to create
#
# === Actions
# - Copies a new jetty default file
# - Creates solr home directory
# - Downloads solr 4.4.0, extracts war and copies logging jars
# - Creates solr data directory
# - Creates solr config file with cores specified
# - Links solr home directory to jetty webapps directory
#
class solr::config(
  $cores         = 'UNSET',
  $jetty_port    = '8080',
  $download_site = $solr::params::download_site,
  $solr_version  = $solr::params::solr_version,
  $jetty_port    = $solr::params::jetty_port
) inherits solr::params {

  $jetty_home     = $::solr::params::jetty_home
  $solr_home      = $::solr::params::solr_home
  $file_name      = "solr-${solr_version}.tgz"

  #Copy the jetty config file
  file { '/etc/default/jetty':
    ensure  => file,
    owner   => 'jetty',
    group   => 'jetty',
    content => template('solr/jetty-default.erb'),
    require => Package[$solr::params::jetty_package],
  }

  file { $solr_home:
    ensure    => directory,
    owner     => 'jetty',
    group     => 'jetty',
    require   => Package[$solr::params::jetty_package],
  }

  # download only if WEB-INF is not present and tgz file is not in /tmp:
  exec { 'solr-download':
    command   =>  "wget ${download_site}/${solr_version}/${file_name}",
    cwd       =>  '/tmp',
    creates   =>  "/tmp/${file_name}",
    onlyif    =>  "test ! -d ${solr_home}/WEB-INF && test ! -f /tmp/${file_name}",
    timeout   =>  0,
    require   => File[$solr_home],
  }

  exec { 'extract-solr':
    path      =>  ['/usr/bin', '/usr/sbin', '/bin'],
    command   =>  "tar xzvf ${file_name}",
    cwd       =>  '/tmp',
    onlyif    =>  "test -f /tmp/${file_name} && test ! -d /tmp/solr-${solr_version}",
    require   =>  Exec['solr-download'],
  }

  # have to copy logging jars separately from solr 4.3 onwards
  exec { 'copy-solr':
    path      =>  ['/usr/bin', '/usr/sbin', '/bin'],
    command   =>  "jar xvf /tmp/solr-${solr_version}/dist/solr-${solr_version}.war; cp /tmp/solr-${solr_version}/example/lib/ext/*.jar WEB-INF/lib",
    cwd       =>  $solr_home,
    onlyif    =>  "test ! -d ${solr_home}/WEB-INF",
    require   =>  Exec['extract-solr'],
  }

  file { '/var/lib/solr':
    ensure    => directory,
    owner     => 'jetty',
    group     => 'jetty',
    mode      => '0700',
    require   => Package[$solr::params::jetty_package],
  }

  file { "${solr_home}/solr.xml":
    ensure    => 'file',
    owner     => 'jetty',
    group     => 'jetty',
    content   => template('solr/solr.xml.erb'),
    require   => File['/etc/default/jetty'],
  }

  file { [$jetty_home, "${jetty_home}/webapps"]:
    ensure  => directory,
    require => Package[$solr::params::jetty_package],
  }

  file { "${jetty_home}/webapps/solr":
    ensure    => 'link',
    target    => $solr_home,
    require   => [
      File["${jetty_home}/webapps"],
      File["${solr_home}/solr.xml"]
    ]
  }

  solr::core { $cores:
    require   =>  File["${jetty_home}/webapps/solr"],
  }
}

