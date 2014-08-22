# == Class: solr::params
# This class sets up some required parameters
# http://archive.apache.org/dist/lucene/solr/4.4.0/solr-4.4.0.tgz
# === Actions
# - Specifies jetty and solr home directories
# - Specifies the default core
#
class solr::params {

  $jetty_home     = '/usr/share/jetty'
  $solr_home      = '/usr/share/solr'
  #$solr_version   = '4.9.0'
  $solr_version   = '4.4.0'
  $cores          = ['default']
  #$download_site  = 'http://www.eng.lsu.edu/mirrors/apache/lucene/solr'
  $download_site  = 'http://archive.apache.org/dist/lucene/solr/'
  $jetty_port     = '8993'

  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      $java_package   = 'java-1.7.0-openjdk'
      $jetty_package  = 'jetty-eclipse'
      $libjetty_extra = false
    }
    'Debian', 'Ubuntu': {
      $java_package   = 'default-jdk'
      $jetty_package  = 'jetty'
      $libjetty_extra = 'libjetty-extra'
    }
    default: {
      fail('Sorry, do not know how to handle this OS.')
    }
  }

}
