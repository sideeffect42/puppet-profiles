class profiles::jenkins {

  include ::jenkins

#  class{ 'jenkins::plugins':
#    plugin_hash => {
#      'git' => {},
#      'git-client' => {},
#      'parameterized-trigger' => {},
#      'ssh-credentials' => {},
#      'credentials' => {},
#      'scm-api' => {},
#      'jclouds-jenkins' => {},
#      'promoted-builds' => {},
#    }
#  }

  File {
    owner => 'jenkins',
    group => 'jenkins',
  }

  file { '/var/lib/jenkins/.ssh':
    ensure => directory,
    mode   => '0700',
  }

  file { '/var/lib/jenkins/.ssh/id_rsa':
    mode    => '0600',
    content => hiera('jenkins::ssh_key', undef),
  }

  $staging_dsl  = hiera('jenkins::staging_dsl', false)
  $stage_from   = hiera('jenkins::stage_from', $_stage)
  $stage_to     = hiera('jenkins::stage_to', undef)
  $staging_repo = hiera('jenkins::staging_repo', undef)
  $tld          = hiera('jenkins::staging_tld', $domain)

  if $staging_dsl {
    file { '/var/lib/jenkins/jobs/staging-dsl':
      ensure => 'directory',
      mode   => '0755',
      owner  => 'jenkins',
      group  => 'jenkins',
    }
    file { '/var/lib/jenkins/jobs/staging-dsl/config.xml':
      content => template("$module_name/jenkins/config.xml.erb"),
      mode    => '0644',
      owner   => 'jenkins',
      group   => 'jenkins',
      require => File['/var/lib/jenkins/jobs/staging-dsl'],
      notify  => Service['jenkins'],
    }
  }

}
