# == Class: solr::service
# This class sets up solr service
#
# === Actions
# - Sets up jetty service
#
class solr::service inherits solr::params {

  #restart after copying new config
  service { 'jetty':
    ensure      => running,
    hasrestart  => true,
    hasstatus   => true,
    require     => Package[$solr::params::jetty_package],
  }

}


