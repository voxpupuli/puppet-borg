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
  ## additional packages
  # centos: perl-autodie perl-Carp-Assert perl-DateTime perl-DB_File perl-File-Slurp perl-IO-Compress perl-IPC-Run
  # ... okay, List::Util is way to old...

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
