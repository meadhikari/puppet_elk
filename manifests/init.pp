class { 'elasticsearch':
  version => '1.4.4',
  manage_repo  => true,
  repo_version => '1.4',
  status => 'enabled',
  java_install => true


}
elasticsearch::instance { 'logstash': }
class { 'logstash': 
  manage_repo  => true,
  repo_version => '1.3',
  status => 'enabled',
  init_defaults_file => 'puppet:///modules/logstash/logstash',
  require => Class['elasticsearch']

}
logstash::configfile { 'syslog':
  source => 'puppet:///modules/logstash/syslog',
  order  => 20
}

class { '::kibana4':
  package_ensure    => '4.0.0-linux-x64',
  package_provider  => 'archive',
  symlink           => false,
  manage_user       => true,
  kibana4_user      => kibana4,
  kibana4_group     => kibana4,
  kibana4_gid       => 200,
  kibana4_uid       => 200,
  elasticsearch_url => 'http://localhost:9200',
}
class { "nginx":
source_dir       => "puppet:///modules/nginx",
source_dir_purge => false,
}
