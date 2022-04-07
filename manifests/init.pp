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
# @param manage_prune
#   Enable management of backup prunes. If this is set to `false` all `keep_*` parameters are ignored.
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
# @param compression
#   Compression method and level to use. See the output of `borg help compression` for available options.
#
# @param source_paths
#   A list of relative or absolute paths to backup.
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
#   The path on the remote server where the backups should be written to. $username will be prepended
#
# @param backupdatadir
#   The path where additional backup data should be stored.
#
# @param absolutebackupdestdir
#  By defaults, backups will be written on the remote host to $username/$backupdestdir. if $absolutebackupdestdir is set this will be used instead
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
# @param install_fatpacked_cpanm
#   cpanm is required on systems where we want to have App::BorgRestore. Legacy systems ship a too old cpanm version. For those operating systems we can install the upstream version.
#
# @param proxy_type
#   configue a network proxy *type* for the archive resources in this module. You also need to set `proxy_server` if you need a proxy.
#
# @param proxy_server
#   Configurea network proxy for the archive resources in this module. By default no proxy will be used
#
# @param manage_package
#   Enable/Disable management of the actual borg package. People on legacy OS or isolated environments can disable this and manage the binary in their profile.
#
# @param ssh_key_type
#   configure your most favourite ssh key type. This will be used to connect to the remote borg server.
#
# @param backuptime
#   Configure the name of each backupjob and the time of that job.
#
# @param ssh_proxyjump
#   Configure possible bastionhosts for the connection.
#
# @param wants
#   Array of units where the borg-backup service should depend on
#
# @param requires
#   Array of units which the borg-backup service should require
#
# @param after
#   Array of units that should be started before the borg-backup service
#
# @param pre_backup_script
#   BASH code to be executed before the backup job starts. If you wish to use snapshots, create them here.
#
# @param post_backup_script
#   BASH code to be executed after the backup job has finished. If you need to perform any cleanup do so here.
#
# @see https://metacpan.org/pod/App::BorgRestore
#
class borg (
  Variant[String[1],Array[String[1]]] $package_name,
  String[1] $backupserver,
  Boolean $install_restore_script,
  Stdlib::Absolutepath $restore_script_path,
  Boolean $manage_repository,
  Boolean $install_fatpacked_cpanm,
  Boolean $create_prometheus_metrics                       = true,
  Boolean $use_upstream_reporter                           = false,
  Boolean $update_borg_restore_db_after_backuprun          = true,
  Boolean $manage_prune                                    = true,
  Integer[0] $keep_yearly                                  = 3,
  Integer[0] $keep_monthly                                 = 24,
  Integer[0] $keep_weekly                                  = 36,
  Integer[0] $keep_daily                                   = 60,
  Integer[0] $keep_within                                  = 30,
  String[1] $compression                                   = 'lz4',
  Array[String[1]] $source_paths                           = ['/'],
  Array[Stdlib::Absolutepath] $excludes                    = ['/tmp', '/sys', '/dev', '/proc', '/run', '/media', '/var/lib/nfs/rpc_pipefs'],
  Array[Stdlib::Absolutepath] $includes                    = ['/', '/boot', '/boot/efi', '/boot/EFI', '/var/log'],
  String[1] $backupdestdir                                 = 'borg',
  Stdlib::Absolutepath $backupdatadir                      = '/root/backup-data/',
  Optional[String[1]] $absolutebackupdestdir               = undef,
  Array[String[1]] $exclude_pattern                        = ['sh:/home/*/.cache/*', 'sh:/root/.cache/*', 'sh:/var/cache/pacman/pkg/*'],
  Array[String[1]] $additional_exclude_pattern             = [],
  Array[String[1]] $restore_dependencies                   = [],
  String[1] $package_ensure                                = present,
  Array[Stdlib::Absolutepath] $additional_excludes         = [],
  Array[Stdlib::Absolutepath] $additional_includes         = [],
  String[1] $username                                      = $facts['networking']['hostname'],
  Stdlib::Port $ssh_port                                   = 22,
  Pattern[/^\d*\.\d*\.\d*$/] $borg_restore_version         = '3.4.4',
  Optional[Enum['none', 'ftp','http','https']] $proxy_type = undef,
  Optional[String[1]] $proxy_server                        = undef,
  Boolean $manage_package                                  = true,
  Enum['rsa', 'ed25519'] $ssh_key_type                     = 'ed25519',
  Hash[String[1],String[1]] $backuptime                    = { 'default' => '18:30:00' },
  Optional[String[1]] $ssh_proxyjump                       = undef,
  Array[String[1]] $wants                                  = ['network-online.target'],
  Array[String[1]] $requires                               = [],
  Array[String[1]] $after                                  = ['network-online.target'],
  Optional[String[1]] $pre_backup_script                   = undef,
  Optional[String[1]] $post_backup_script                  = undef,
) {
  contain borg::install
  contain borg::config
  contain borg::service

  Class['borg::install']
  -> Class['borg::config']
  ~> Class['borg::service']
}
