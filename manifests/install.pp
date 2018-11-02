# @api private
# This class handles the installation. Avoid modifying private classes.
class borg::install {

  if $facts['os']['osfamily'] == 'FreeBSD' {
    $real_package_provider = 'portsng'
  } else {
    $real_package_provider = undef
  }
  # ports and portupgrade provider are not available providers on FreeBSD 11
  package{$borg::package_name:
    ensure   => $borg::package_ensure,
    provider => $real_package_provider,
  }

  if $borg::install_restore_script {
    $venv_directory = '/opt/BorgRestore'
    ensure_packages(['perl-App-cpanminus', 'perl-local-lib', 'perl-Test-Simple', 'gcc'], {before => Exec['install_borg_restore']})
    file{$venv_directory:
      ensure => 'directory',
    }
    -> exec{'install_borg_restore':
      command     => 'cpanm -l /opt/BorgRestore App::BorgRestore',
      creates     => "${venv_directory}/bin/borg-restore.pl",
      path        => "${$venv_directory}/bin::/usr/sbin:/usr/bin:/sbin:/bin",
      environment => ["PERL_MB_OPT='--install_base ${venv_directory}'", "PERL_MM_OPT='INSTALL_BASE=${venv_directory}'", "PERL5LIB='${venv_directory}/lib/perl5'", "PERL_LOCAL_LIB_ROOT=${venv_directory}"],
      timeout     => 600,
      cwd         => '/root',
    }
    file{'/usr/local/bin/borg-restore.pl':
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
      archive{'/opt/0.1.1.tar.gz':
        extract_path  => '/opt',
        creates       => '/opt/prometheus-borg-exporter-0.1.1/borg_exporter',
        source        => 'https://github.com/teemow/prometheus-borg-exporter/archive/0.1.1.tar.gz',
        extract       => true,
        checksum      => '307432be6453d83825b18537e105d1180f2d13fa',
        checksum_type => 'sha1',
      }
      ~> file{'/usr/local/bin/borg_exporter':
        ensure => 'file',
        source => '/opt/prometheus-borg-exporter-0.1.1/borg_exporter',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    } else {
      file{'/usr/local/bin/borg_exporter':
        ensure  => 'file',
        content => epp("${module_name}/borg_exporter.sh.epp"),
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }
    }
    file{'/etc/borg':
      ensure  => 'file',
      content => epp("${module_name}/borg.epp", {'username' => $borg::username}),
    }
  }

  # setup a profile to export the backup server/path. Otherwise the CLI tooles don't work
  file{'/etc/profile.d/borg.sh':
    ensure  => 'file',
    content => epp("${module_name}/borg.sh.epp", {'username' => $borg::username}),
  }
}
