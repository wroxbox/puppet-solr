# == Class: solr::install
# This class installs the required packages for jetty
#
# === Actions
# - Installs default jdk
# - Installs jetty and extra libs
#
class solr::install inherits solr::params {

  if !defined(Package[$solr::params::java_package]) {
    package { $solr::params::java_package:
      ensure => present
    }
  }

  if !defined(Package[$solr::params::jetty_package]) {
    package { $solr::params::jetty_package:
      ensure  => present,
      require => Package[$solr::params::java_package],
    }
  }

  if $solr::params::libjetty_extra and !defined(Package[$solr::params::libjetty_extra]) {
    package { $solr::params::libjetty_extra:
      ensure  => present,
      require => Package[$solr::params::jetty_package],
    }
  }

  if (!defined(User['jetty'])) {
    user { 'jetty':
      ensure => present
    }
  }

  if !defined(Package['wget']) {
    package { 'wget':
      ensure => present,
    }
  }

}

