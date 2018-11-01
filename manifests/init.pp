class borg (
  Variant[String[1],Array[String[1]]] $package_name,
  Boolean $create_prometheus_metrics,
  Boolean $use_upstream_reporter,
  Boolean $update_borg_restore_db_after_backuprun,
  Integer[1] $keep_yearly,
  Integer[1] $keep_monthly,
  Integer[1] $keep_weekly,
  Integer[1] $keep_daily,
  Integer[1] $keep_within,
  Array[Stdlib::Absolutepath] $excludes,
  Array[Stdlib::Absolutepath] $includes,
  String[1] $backupserver,
  Boolean $install_restore_script,
  String[1] $package_ensure                        = present,
  Array[Stdlib::Absolutepath] $additional_excludes = [],
  Array[Stdlib::Absolutepath] $additional_includes = [],
  String[1] $username                              = $facts['hostname'],
) {

  contain borg::install
  contain borg::config
  contain borg::service

  Class['borg::install']
  -> Class['borg::config']
  ~> Class['borg::service']
}
