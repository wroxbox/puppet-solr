# == Class: solr::install
# This class installs the required packages for jetty
#
# === Actions
# - Installs default jdk
# - Installs jetty and extra libs
#
class solr::install {

  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      $java_package = 'java-1.7.0-openjdk'
    }
    'Debian', 'Ubuntu': {
      $java_package = 'default-jdk'
    }
    default: {
      fail('Sorry, do not know how to handle this OS.')
    }
  }

  if !defined(Package[$java_package]) {
    package { $java_package:
      ensure => present
    }
  }

  if !defined(Package['jetty']) {
    package { 'jetty':
      ensure  => present,
      require => Package[$java_package],
    }
  }

  if !defined(Package['libjetty-extra']) {
    package { 'libjetty-extra':
      ensure  => present,
      require => Package['jetty'],
    }
  }

  if !defined(Package['wget']) {
    package { 'wget':
      ensure => present,
    }
  }

}

