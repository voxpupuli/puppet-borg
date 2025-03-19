# @api private
class borg::config (
  Pattern[/^\d*\.\d*\.\d*$/] $default_version = '1.2.0',
) {
  assert_private()

  $backupdestdir = $borg::absolutebackupdestdir ? {
    Undef   => "${borg::username}/${borg::backupdestdir}",
    default => $borg::absolutebackupdestdir,
  }
  $numeric = versioncmp(pick(fact('borgbackup.version'), $default_version), '1.2.0') ? {
    -1      => '--numeric-owner',
    default => '--numeric-ids',
  }

  # script to run the backup
  file { '/usr/local/bin/borg-backup':
    ensure  => 'file',
    content => epp("${module_name}/borg-backup.sh.epp",
      {
        'manage_prune'       => $borg::manage_prune,
        'keep_within'        => $borg::keep_within,
        'keep_daily'         => $borg::keep_daily,
        'keep_weekly'        => $borg::keep_weekly,
        'keep_monthly'       => $borg::keep_monthly,
        'keep_yearly'        => $borg::keep_yearly,
        'compression'        => $borg::compression,
        'working_directory'  => $borg::working_directory,
        'backupdestdir'      => $backupdestdir,
        'backupdatadir'      => $borg::backupdatadir,
        'pre_backup_script'  => $borg::pre_backup_script,
        'post_backup_script' => $borg::post_backup_script,
        'numeric'            => $numeric,
        'upload_ratelimit'   => $borg::upload_ratelimit,
    }),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  $ensure = $facts['os']['name'] ? {
    'Archlinux' => 'absent',
    default     => 'file'
  }

  # setup the config for the restore script
  file { '/etc/borg-restore.cfg':
    ensure  => 'file',
    content => epp("${module_name}/borg-restore.cfg.epp", { 'backupdestdir' => $backupdestdir, }),
  }
  # config file is deprecated and should be absent
  file { '/etc/backup-sh-conf.sh':
    ensure => 'absent',
  }
  # create the backup key for a user
  ssh_keygen { 'root_borg':
    type     => $borg::ssh_key_type,
    filename => "/root/.ssh/id_${borg::ssh_key_type}_borg",
    home     => '/root',
    user     => 'root',
  }

  # /root/.ssh/config entry for the backup server
  if $borg::ssh_proxyjump {
    ssh::client::config::user { 'root':
      ensure        => present,
      user_home_dir => '/root',
      options       => {
        'Host backup' => {
          'User'         => $borg::username,
          'IdentityFile' => "~/.ssh/id_${borg::ssh_key_type}_borg",
          'Hostname'     => $borg::backupserver,
          'Port'         => $borg::ssh_port,
          'ProxyJump'    => $borg::ssh_proxyjump,
        },
      },
    }
  } else {
    ssh::client::config::user { 'root':
      ensure        => present,
      user_home_dir => '/root',
      options       => {
        'Host backup' => {
          'User'         => $borg::username,
          'IdentityFile' => "~/.ssh/id_${borg::ssh_key_type}_borg",
          'Hostname'     => $borg::backupserver,
          'Port'         => $borg::ssh_port,
        },
      },
    }
  }
}
