# Main class, includes all other classes.
#
# @param package_name
#   Name of the borg package
#
# @param create_prometheus_metrics
#   Enable a postrun command to create prometheus compatible metrics about all backups
#
# @param use_upstream_reporter
#   Enable to upstream reporter (see create_prometheus_metrics param) or our vendored version
#
# @param update_borg_restore_db_after_backuprun
#   Enable the restore helper from Florian 'Bluewind' Pritz (https://metacpan.org/release/App-BorgRestore) as another postrun command (see also the install_restore_script parameter)
#
# @param keep_yearly
#   For how many years should we keep our backups?
#
# @param keep_monthly
#   For how many months should we keep our backups?
#
# @param keep_weekly
#   For how many weeks should we keep our backups?
#
# @param keep_daily
#   For how many days should we keep our backups?
#
# @param keep_within
#   For how many days should we keep all backups we have?
#
# @param excludes
#   list of default mountpoints that should be excluded from backups. Every mountpoint needs to be explicitly excluded or included. See also the additional_excludes parameter.
#
# @param includes
#   list of default mountpoints that should be included from backups. Every mountpoint needs to be explicitly excluded or included. See also the additional_includes parameter.
#
# @param backupserver
#   FQDN for the remote server. Will be written into the local ssh client configuration file.
#
# @param install_restore_script
#   Install the restore helper via cpanm.
#
# @param restore_script_path
#   The path to the restore helper.
#
# @param backupdestdir
#   The path on the remote server where the backups should be written to.
#
# @param manage_repository
#   A Boolean that enables/disables repository management. Only true on Ubuntu 16.04 at the moment
#
# @param exclude_pattern
#   We currently support excludes/includes for mountpoints. borg supports also a list of shell glob/regex pattern to filter for files.
#
# @param additional_exclude_pattern
#   Another array of patterns to extend the modules built-in list (`exclude_pattern` parameter).
#
# @param restore_dependencies
#   A list of dependencies for the restore helper.
#
# @param package_ensure
#   Ensure state for the borg package.
#
# @param additional_excludes
#   Another array of mountpoints to extend the modules built-in list (`excludes` parameter).
#
# @param additional_includes
#   Another array of mountpoints to extend to modules built-in list (`includes` parameter).
#
# @param username
#   The ssh username to connect to the remote borg service.
#
# @param ssh_port
#   SSH port for the remote server (default: 22). Will be written into the local ssh client configuration file.
#
# @param borg_restore_version
#   Version for the perl script App::BorgRestore. change this version and the module will upgrade/downgrade it
#
# @see https://metacpan.org/pod/App::BorgRestore
#
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
  Stdlib::Absolutepath $restore_script_path,
  String[1] $backupdestdir,
  Boolean $manage_repository,
  Array[String[1]] $exclude_pattern,
  Array[String[1]] $additional_exclude_pattern     = [],
  Array[String[1]] $restore_dependencies           = [],
  String[1] $package_ensure                        = present,
  Array[Stdlib::Absolutepath] $additional_excludes = [],
  Array[Stdlib::Absolutepath] $additional_includes = [],
  String[1] $username                              = $facts['networking']['hostname'],
  Stdlib::Port $ssh_port                           = 22,
  Pattern[/^\d*\.\d*\.\d*$/] $borg_restore_version = '3.4.3',
) {
  contain borg::install
  contain borg::config
  contain borg::service

  Class['borg::install']
  -> Class['borg::config']
  ~> Class['borg::service']
}
