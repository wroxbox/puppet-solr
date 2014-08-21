# == Class: solr
#
# This module helps you create a multi-core solr install
# from scratch. I'm packaging a version of solr in the files
# directory for convenience. You can replace it with a newer
# version if you like.
#
# IMPORTANT: Works only with Ubuntu as of now. Other platform
# support is most welcome.
#
# === Parameters
#
# [*cores*]
#   "Specify the solr cores you want to create (optional)"
#
# === Examples
#
# Default case, which creates a single core called 'default'
#
#  include solr
#
# If you want multiple cores, you can supply them like so:
#
#  class { 'solr':
#    cores => [ 'development', 'staging', 'production' ]
#  }
#
# You can also manage/create your cores from solr web admin panel.
#
# === Authors
#
# Vamsee Kanakala <vamsee AT riseup D0T net>
#
# === Copyright
#
# Copyright 2012-2013 Vamsee Kanakala, unless otherwise noted.
#
class solr (
  $cores         = 'UNSET',
  $download_site = $solr::params::download_site,
  $version       = '4.9.0',
  $jetty_port    = $solr::params::jetty_port
) inherits solr::params {

  include solr::params

  $all_cores = $cores ? {
    'UNSET'   => $::solr::params::cores,
    default   => $cores
  }

  class {'solr::install': } ->
  class {'solr::config':
    cores         => $all_cores,
    download_site => $download_site,
    solr_version  => $version,
    jetty_port    => $jetty_port
  } ~>
  class {'solr::service': } ->
  Class['solr']

}
