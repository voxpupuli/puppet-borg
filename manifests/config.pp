class borg::config {

  # script to run the backup
  file{'/usr/local/bin/borg-backup':
    ensure  => 'file',
    content => epp("${module_name}/borg-backup.sh.epp", {
      'keep_within'  => $borg::keep_within,
      'keep_daily'   => $borg::keep_daily,
      'keep_weekly'  => $borg::keep_weekly,
      'keep_monthly' => $borg::keep_monthly,
      'keep_yearly'  => $borg::keep_yearly,
      'username'     => $borg::username,
    }),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
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

  # config file with all excludes and includes
  file{'/etc/backup-sh-conf.sh':
    ensure  => 'file',
    content => epp("${module_name}/backup-sh-conf.sh.epp"),
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
  ssh::client::config::user{'root_borg':
    ensure        => present,
    #user          => 'root',
    user_home_dir => '/root',
    options       => {
      'Host backup' => {
        'User'         => $borg::username,
        'IdentityFile' => '~/.ssh/id_ed25519_borg',
        'Hostname'     => $borg::backupserver,
      },
    },
  }
}
