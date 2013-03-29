#
define deploy::rails(
  $ensure          = 'present',
  $user            = $name,
  $ssh_key         = undef,
  $ssh_key_options = undef,
  $deploy_to       = undef,
  $services        = false,
  $server_name     = undef,
  $configs         = undef,

  $database_url    = undef,
  $env             = 'production',
  $num_web_workers = 2
) {
  include 'deploy::params'

  $deploy_path = $deploy_to ? {
    undef   => "${deploy::params::deploy_to}/${name}",
    default => $deploy_to
  }

  deploy::application{ $name:
    ensure          => 'present',
    user            => $user,
    ssh_key         => $ssh_key,
    ssh_key_options => $ssh_key_options,
    deploy_to       => $deploy_path,
    services        => $services,
    server_name     => $server_name,
    configs         => $configs
  }

  if $database_url != undef {
    file { "${deploy_path}/shared/config/database.yml":
      ensure  => 'present',
      owner   => $user,
      group   => $user,
      mode    => '0640',
      content => template('deploy/database.yml.erb'),
      require => File["${deploy_path}/shared"]
    }
  }

  file{ "${deploy_path}/shared/config/unicorn.rb":
    ensure  => 'present',
    owner   => $user,
    group   => $user,
    mode    => '0640',
    content => template('deploy/unicorn.rb.erb'),
    require => File["${deploy_path}/shared/config"]
  }
}
