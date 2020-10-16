# @api private
# This class handles the installation. Avoid modifying private classes.
class borg::install {
  assert_private()

  if $facts['os']['osfamily'] == 'FreeBSD' {
    $real_package_provider = 'portsng'
  } else {
    $real_package_provider = undef
  }

  # at the moment, we only support Ubuntu
  if $borg::manage_repository {
    include apt
    apt::ppa { 'ppa:costamagnagianfranco/borgbackup':
      package_manage => true,
      before         => Package[$borg::package_name],
    }
  }
  # ports and portupgrade provider are not available providers on FreeBSD 11
  package { $borg::package_name:
    ensure   => $borg::package_ensure,
    provider => $real_package_provider,
  }

  if $borg::install_restore_script {
    if $borg::install_fatpacked_cpanm {
      archive { '/opt/Menlo-Legacy-1.9022.tar.gz':
        extract_path  => '/opt',
        extract       => true,
        creates       => '/opt/cpanminus-Menlo-Legacy-1.9022',
        source        => 'https://github.com/miyagawa/cpanminus/archive/Menlo-Legacy-1.9022.tar.gz',
        checksum      => '2765ec98c48f85d7652b346d671a0fb3f5cfe4bd',
        checksum_type => 'sha1',
        proxy_type    => $borg::proxy_type,
        proxy_server  => $borg::proxy_server,
      }
      ~> file { '/usr/local/bin/cpanm':
        ensure => 'file',
        source => '/opt/cpanminus-Menlo-Legacy-1.9022/App-cpanminus/cpanm',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        before => Exec['install_borg_restore'],
      }
    }
    $venv_directory = '/opt/BorgRestore'
    ensure_packages($borg::restore_dependencies, { before => Exec['install_borg_restore'] })
    $basic_env_vars = ["PERL_MB_OPT='--install_base ${venv_directory}'", "PERL_MM_OPT='INSTALL_BASE=${venv_directory}'", "PERL5LIB='${venv_directory}/lib/perl5'", "PERL_LOCAL_LIB_ROOT=${venv_directory}", 'HOME=/root']

    $env_vars = $borg::proxy_server ? {
      Undef   => $basic_env_vars,
      default => $basic_env_vars + ["${borg::proxy_type}_proxy=${borg::proxy_server}"],
    }
    file { $venv_directory:
      ensure => 'directory',
    }
    -> exec { 'install_borg_restore':
      command     => "cpanm --local-lib-contained ${venv_directory} App::BorgRestore@${borg::borg_restore_version}",
      unless      => "perl -T -I /opt/BorgRestore/lib/perl5/ -MApp::BorgRestore -E 'exit (\"\$App::BorgRestore::VERSION\" ne \"${borg::borg_restore_version}\")'",
      path        => "${$venv_directory}/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin",
      environment => $env_vars,
      timeout     => 1200,
      cwd         => '/root',
      require     => Package[$borg::package_name],
    }
    file { '/usr/local/bin/borg-restore.pl':
      ensure  => 'file',
      content => epp("${module_name}/borg-restore.pl"),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }
  }
  # we're now switching to rh-perl524 from centos-sclo-rh (which comes from the foreman module?)
  if $borg::create_prometheus_metrics {
    if $borg::use_upstream_reporter {
      archive { '/opt/0.1.1.tar.gz':
        extract_path  => '/opt',
        creates       => '/opt/prometheus-borg-exporter-0.1.1/borg_exporter',
        source        => 'https://github.com/teemow/prometheus-borg-exporter/archive/0.1.1.tar.gz',
        extract       => true,
        checksum      => '307432be6453d83825b18537e105d1180f2d13fa',
        checksum_type => 'sha1',
        proxy_type    => $borg::proxy_type,
        proxy_server  => $borg::proxy_server,
      }
      ~> file { '/usr/local/bin/borg_exporter':
        ensure => 'file',
        source => '/opt/prometheus-borg-exporter-0.1.1/borg_exporter',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    } else {
      file { '/usr/local/bin/borg_exporter':
        ensure  => 'file',
        content => epp("${module_name}/borg_exporter.sh.epp"),
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }
    }
    file { '/etc/borg':
      ensure  => 'file',
      content => epp("${module_name}/borg.epp", {
          'username'      => $borg::username,
          'backupdestdir' => $borg::backupdestdir,
      }),
    }
  }

  # setup a profile to export the backup server/path. Otherwise the CLI tooles don't work
  file { '/etc/profile.d/borg.sh':
    ensure  => 'file',
    content => epp("${module_name}/borg.sh.epp", {
        'username'      => $borg::username,
        'backupdestdir' => $borg::backupdestdir,
    }),
  }
}
