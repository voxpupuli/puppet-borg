class borg::service {
  # there isn't any real service
  # borg runs via a systemd timer
  # You don't have systemd? GO AWAY!

  if $facts['systemd'] {
    systemd::unit_file{'borg-backup.service':
      content => epp("${module_name}/borg-backup.service.epp", {
        'create_prometheus_metrics' => $borg::create_prometheus_metrics,
        'restore_script_path'       => $borg::restore_script_path
        }
      ),
    }
    -> systemd::unit_file{'borg-backup.timer':
      content => epp("${module_name}/borg-backup.timer.epp"),
    }
    -> service{'borg-backup.timer':
      ensure => 'running',
      enable => true,
    }
  }
}
