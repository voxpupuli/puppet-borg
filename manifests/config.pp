class borg::config {

  # script to run the backup
  file{'/usr/local/bin/borg-backup.py':
    ensure => 'file',
    source => "puppet:///modules/${module_name}/borg-backup.py",
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  $ensure = $facts['os']['name'] ? {
    'Archlinux' => 'absent',
    default     => 'file'
  }

  # script to make restores and create sqlite db
  file{'/usr/local/bin/borg-restore':
    ensure  => $ensure,
    content => epp("${module_name}/borg-restore.pl.epp"),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  # create the backup key for a user
  borg::ssh_keygen{'root_borg':
    type     => 'ed25519',
    filename => '/root/.ssh/id_ed25519_borg',
    home     => '/root',
    user     => 'root',
  }

  # /root/.ssh/config entry for the backup server
  ssh::client::config::user{'root':
    ensure        => present,
    user_home_dir => '/root',
    options       => {
      'Host backup' => {
        'User'         => $borg::username,
        'IdentityFile' => '~/.ssh/id_ed25519_borg',
        'Hostname'     => $borg::backupserver,
      },
    },
  }

  # Write /etc/borg-backup.yaml config file
  $config_content = {
    'borg' => {
      'repo' => {
        'type'       => 'borgserver',
        'server'     => {
          'hostname'   => $borg::backupserver,
          'remote_dir' => $borg::username,
        },
      },
      'prune' => {
        'keep-within'  => $borg::keep_within,
        'keep-daily'   => $borg::keep_daily,
        'keep-weekly'  => $borg::keep_weekly,
        'keep-monthly' => $borg::keep_monthly,
        'keep-yearly'  => $borg::keep_yearly,
      },
    },
    'lvm' => {
      'use_snapshots' => false,        
    },
    'include' => {
      'mountpoints' => concat($borg::includes, $borg::additonal_includes),
      'paths'       => [],
    },
    'exclude' => {
      'mountpoints' => concat($borg::excludes, $borg::additonal_excludes),
      'paths'       => [],
    },
  }

  file{'/etc/borg-backup.yaml':
    ensure  => 'file',
    content => $config_content.to_yaml,
    mode    => '0655',
    owner   => 'root',
    group   => 'root',
  }
}
