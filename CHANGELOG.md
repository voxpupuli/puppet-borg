# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.1.0](https://github.com/voxpupuli/puppet-borg/tree/v4.1.0) (2023-08-23)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- puppet/ssh\_keygen: Allow 7.x [\#180](https://github.com/voxpupuli/puppet-borg/pull/180) ([bastelfreak](https://github.com/bastelfreak))
- puppet/systemd: Allow 5.x [\#179](https://github.com/voxpupuli/puppet-borg/pull/179) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/vcsrepo: Allow 6.x [\#178](https://github.com/voxpupuli/puppet-borg/pull/178) ([bastelfreak](https://github.com/bastelfreak))
- saz/ssh: Allow 11.x [\#177](https://github.com/voxpupuli/puppet-borg/pull/177) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 9.x [\#172](https://github.com/voxpupuli/puppet-borg/pull/172) ([bastelfreak](https://github.com/bastelfreak))

## [v4.0.0](https://github.com/voxpupuli/puppet-borg/tree/v4.0.0) (2023-08-23)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v3.2.0...v4.0.0)

**Breaking changes:**

- Drop EL7 support  [\#175](https://github.com/voxpupuli/puppet-borg/pull/175) ([bastelfreak](https://github.com/bastelfreak))
- Drop Puppet 6 support [\#174](https://github.com/voxpupuli/puppet-borg/pull/174) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Puppet 8 support [\#173](https://github.com/voxpupuli/puppet-borg/pull/173) ([bastelfreak](https://github.com/bastelfreak))
- bump puppet/systemd to \< 5.0.0 [\#168](https://github.com/voxpupuli/puppet-borg/pull/168) ([jhoblitt](https://github.com/jhoblitt))

## [v3.2.0](https://github.com/voxpupuli/puppet-borg/tree/v3.2.0) (2022-12-21)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v3.1.0...v3.2.0)

**Implemented enhancements:**

- saz/ssh: Allow 10.x [\#164](https://github.com/voxpupuli/puppet-borg/pull/164) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.0](https://github.com/voxpupuli/puppet-borg/tree/v3.1.0) (2022-07-10)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Implement support for older borg versions [\#161](https://github.com/voxpupuli/puppet-borg/pull/161) ([bastelfreak](https://github.com/bastelfreak))
- Add version fact [\#160](https://github.com/voxpupuli/puppet-borg/pull/160) ([bastelfreak](https://github.com/bastelfreak))
- borg prune: List archives that wont be deleted [\#159](https://github.com/voxpupuli/puppet-borg/pull/159) ([bastelfreak](https://github.com/bastelfreak))

## [v3.0.0](https://github.com/voxpupuli/puppet-borg/tree/v3.0.0) (2022-04-08)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v2.4.0...v3.0.0)

**Breaking changes:**

- Drop support for Debian 9 since it's EoL [\#156](https://github.com/voxpupuli/puppet-borg/pull/156) ([hashworks](https://github.com/hashworks))
- Fedora: Drop support [\#154](https://github.com/voxpupuli/puppet-borg/pull/154) ([bastelfreak](https://github.com/bastelfreak))
- Add support for snapshots using pre/post scripts; replace `--numeric-owner` with `--numeric-ids` [\#150](https://github.com/voxpupuli/puppet-borg/pull/150) ([hashworks](https://github.com/hashworks))

**Implemented enhancements:**

- Add configureable working directory from where the backup should be created [\#155](https://github.com/voxpupuli/puppet-borg/pull/155) ([hashworks](https://github.com/hashworks))
- Add Ubuntu 20.04 support [\#153](https://github.com/voxpupuli/puppet-borg/pull/153) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian 11 support [\#152](https://github.com/voxpupuli/puppet-borg/pull/152) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- saz/ssh: Allow 9.x / Fix CentOS 8 acceptance tests  [\#151](https://github.com/voxpupuli/puppet-borg/pull/151) ([bastelfreak](https://github.com/bastelfreak))
- Implement Arch Linux acceptance testing [\#149](https://github.com/voxpupuli/puppet-borg/pull/149) ([bastelfreak](https://github.com/bastelfreak))

## [v2.4.0](https://github.com/voxpupuli/puppet-borg/tree/v2.4.0) (2021-12-27)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v2.3.1...v2.4.0)

**Implemented enhancements:**

- Implement support for custom unit dependencies [\#146](https://github.com/voxpupuli/puppet-borg/pull/146) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.1](https://github.com/voxpupuli/puppet-borg/tree/v2.3.1) (2021-12-07)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v2.3.0...v2.3.1)

**Fixed bugs:**

- Make sure /etc/borg contains the absolutebackupdestdir if it is set [\#142](https://github.com/voxpupuli/puppet-borg/pull/142) ([hashworks](https://github.com/hashworks))
- Surround mountpoints in configuration file with quotes, avoid whitespace prefix for exclude patterns [\#141](https://github.com/voxpupuli/puppet-borg/pull/141) ([hashworks](https://github.com/hashworks))

## [v2.3.0](https://github.com/voxpupuli/puppet-borg/tree/v2.3.0) (2021-12-03)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Add ability to specify compression method and level [\#138](https://github.com/voxpupuli/puppet-borg/pull/138) ([hashworks](https://github.com/hashworks))
- Add ability to disable borg prune call completly [\#137](https://github.com/voxpupuli/puppet-borg/pull/137) ([hashworks](https://github.com/hashworks))

**Merged pull requests:**

- Make sure README links are not 404 outside of GitHub [\#139](https://github.com/voxpupuli/puppet-borg/pull/139) ([hashworks](https://github.com/hashworks))
- Update hiera documentation in README.md [\#135](https://github.com/voxpupuli/puppet-borg/pull/135) ([bastelfreak](https://github.com/bastelfreak))

## [v2.2.0](https://github.com/voxpupuli/puppet-borg/tree/v2.2.0) (2021-10-14)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v2.1.2...v2.2.0)

**Implemented enhancements:**

- Add support for jumphosts [\#128](https://github.com/voxpupuli/puppet-borg/pull/128) ([sebastianberm](https://github.com/sebastianberm))

**Merged pull requests:**

- saz/ssh: Allow 8.x [\#124](https://github.com/voxpupuli/puppet-borg/pull/124) ([bastelfreak](https://github.com/bastelfreak))

## [v2.1.2](https://github.com/voxpupuli/puppet-borg/tree/v2.1.2) (2021-08-26)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v2.1.1...v2.1.2)

**Fixed bugs:**

- Document CentOS8 requirement of PowerTools repo [\#119](https://github.com/voxpupuli/puppet-borg/pull/119) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Allow up-to-date dependencies [\#122](https://github.com/voxpupuli/puppet-borg/pull/122) ([smortex](https://github.com/smortex))

## [v2.1.1](https://github.com/voxpupuli/puppet-borg/tree/v2.1.1) (2021-07-26)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v2.1.0...v2.1.1)

**Fixed bugs:**

- fix broken README.md badges [\#114](https://github.com/voxpupuli/puppet-borg/pull/114) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- switch from camptocamp/systemd to voxpupuli/systemd [\#115](https://github.com/voxpupuli/puppet-borg/pull/115) ([bastelfreak](https://github.com/bastelfreak))

## [v2.1.0](https://github.com/voxpupuli/puppet-borg/tree/v2.1.0) (2021-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Add support for multiple / variable backup times. [\#111](https://github.com/voxpupuli/puppet-borg/pull/111) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Start backups only if network is available [\#110](https://github.com/voxpupuli/puppet-borg/pull/110) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Scheduling the time the backup is ran [\#91](https://github.com/voxpupuli/puppet-borg/issues/91)

## [v2.0.0](https://github.com/voxpupuli/puppet-borg/tree/v2.0.0) (2021-06-29)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.6.0...v2.0.0)

**Breaking changes:**

- Drop EoL Ubuntu 16.04 support [\#101](https://github.com/voxpupuli/puppet-borg/pull/101) ([bastelfreak](https://github.com/bastelfreak))
- Drop EoL Puppet 5 support; Add Puppet 7 support [\#99](https://github.com/voxpupuli/puppet-borg/pull/99) ([bastelfreak](https://github.com/bastelfreak))
- \[skip ci\] Drop soon-EOL CentOS/RHEL 6 [\#81](https://github.com/voxpupuli/puppet-borg/pull/81) ([bastelfreak](https://github.com/bastelfreak))
- Drop Fedora 22-31, add 32/33 [\#80](https://github.com/voxpupuli/puppet-borg/pull/80) ([bastelfreak](https://github.com/bastelfreak))
- Drop CentOS/RHEL 5 from metadata.json [\#79](https://github.com/voxpupuli/puppet-borg/pull/79) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Debian 10 support [\#107](https://github.com/voxpupuli/puppet-borg/pull/107) ([bastelfreak](https://github.com/bastelfreak))
- Enable user to configure the backup destination path [\#105](https://github.com/voxpupuli/puppet-borg/pull/105) ([bastelfreak](https://github.com/bastelfreak))
- puppet/ssh\_keygen: Allow 5.x [\#98](https://github.com/voxpupuli/puppet-borg/pull/98) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 7.x [\#96](https://github.com/voxpupuli/puppet-borg/pull/96) ([bastelfreak](https://github.com/bastelfreak))
- camptocamp/systemd: allow 3.x [\#95](https://github.com/voxpupuli/puppet-borg/pull/95) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/vcsrepo: Allow 4.x & 5.x [\#94](https://github.com/voxpupuli/puppet-borg/pull/94) ([bastelfreak](https://github.com/bastelfreak))
- make ssh key type configureable [\#88](https://github.com/voxpupuli/puppet-borg/pull/88) ([bastelfreak](https://github.com/bastelfreak))
- Introduce manage\_package variable [\#87](https://github.com/voxpupuli/puppet-borg/pull/87) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Fix wrong package dependencies on CentOS 8 [\#84](https://github.com/voxpupuli/puppet-borg/pull/84) ([bastelfreak](https://github.com/bastelfreak))
- Keep intervalls: Allow 0 [\#83](https://github.com/voxpupuli/puppet-borg/pull/83) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- beaker: set US locale [\#106](https://github.com/voxpupuli/puppet-borg/pull/106) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/apt: allow 8.x [\#104](https://github.com/voxpupuli/puppet-borg/pull/104) ([bastelfreak](https://github.com/bastelfreak))
- puppet/archive: Allow 5.x [\#103](https://github.com/voxpupuli/puppet-borg/pull/103) ([bastelfreak](https://github.com/bastelfreak))
- saz/ssh: Allow 7.x [\#102](https://github.com/voxpupuli/puppet-borg/pull/102) ([bastelfreak](https://github.com/bastelfreak))

## [v1.6.0](https://github.com/voxpupuli/puppet-borg/tree/v1.6.0) (2020-10-16)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.5.0...v1.6.0)

**Implemented enhancements:**

- Implement proxy support for archive and exec resources [\#75](https://github.com/voxpupuli/puppet-borg/pull/75) ([bastelfreak](https://github.com/bastelfreak))
- update borg-restore.pl 3.4.3-\>3.4.4 [\#74](https://github.com/voxpupuli/puppet-borg/pull/74) ([bastelfreak](https://github.com/bastelfreak))
- borg-backup: Increase logging for create/prune [\#73](https://github.com/voxpupuli/puppet-borg/pull/73) ([bastelfreak](https://github.com/bastelfreak))

## [v1.5.0](https://github.com/voxpupuli/puppet-borg/tree/v1.5.0) (2020-10-09)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.4.0...v1.5.0)

**Implemented enhancements:**

- Implement support for upstream cpanm management / BorgRestore: Add support for upgrades/downgrades [\#66](https://github.com/voxpupuli/puppet-borg/pull/66) ([bastelfreak](https://github.com/bastelfreak))
- installation: Add local bin paths to $PATH [\#64](https://github.com/voxpupuli/puppet-borg/pull/64) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Rework puppet-strings documentation [\#70](https://github.com/voxpupuli/puppet-borg/pull/70) ([bastelfreak](https://github.com/bastelfreak))
- regenerate REFERENCE.md / Add puppet-lint-param-docs linter [\#61](https://github.com/voxpupuli/puppet-borg/pull/61) ([bastelfreak](https://github.com/bastelfreak))

## [v1.4.0](https://github.com/voxpupuli/puppet-borg/tree/v1.4.0) (2020-08-15)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.3.1...v1.4.0)

**Implemented enhancements:**

- borg-backup script: mention env var for passphrase [\#59](https://github.com/voxpupuli/puppet-borg/pull/59) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- modulesync 3.0.0 & puppet-lint updates [\#58](https://github.com/voxpupuli/puppet-borg/pull/58) ([bastelfreak](https://github.com/bastelfreak))

## [v1.3.1](https://github.com/voxpupuli/puppet-borg/tree/v1.3.1) (2020-04-17)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.3.0...v1.3.1)

**Fixed bugs:**

- Backup EFI data as well [\#56](https://github.com/voxpupuli/puppet-borg/pull/56) ([bastelfreak](https://github.com/bastelfreak))
- BorgRestore: Increase exec timeout to 10-\>20min [\#55](https://github.com/voxpupuli/puppet-borg/pull/55) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Use voxpupuli-acceptance [\#54](https://github.com/voxpupuli/puppet-borg/pull/54) ([ekohl](https://github.com/ekohl))

## [v1.3.0](https://github.com/voxpupuli/puppet-borg/tree/v1.3.0) (2020-04-04)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.2.0...v1.3.0)

**Implemented enhancements:**

- Add VZ 7 support [\#51](https://github.com/voxpupuli/puppet-borg/pull/51) ([bastelfreak](https://github.com/bastelfreak))
- Replace vendored ssh\_keygen with voxpupuli/ssh\_keygen [\#50](https://github.com/voxpupuli/puppet-borg/pull/50) ([bastelfreak](https://github.com/bastelfreak))
- Add /var/log to default includes [\#49](https://github.com/voxpupuli/puppet-borg/pull/49) ([bastelfreak](https://github.com/bastelfreak))
- Add CentOS/RedHat 8 to metadata.json [\#48](https://github.com/voxpupuli/puppet-borg/pull/48) ([bastelfreak](https://github.com/bastelfreak))

## [v1.2.0](https://github.com/voxpupuli/puppet-borg/tree/v1.2.0) (2020-02-20)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.1.1...v1.2.0)

**Implemented enhancements:**

- Add fedora 31 support [\#45](https://github.com/voxpupuli/puppet-borg/pull/45) ([kBite](https://github.com/kBite))

**Merged pull requests:**

- update repo links to https [\#44](https://github.com/voxpupuli/puppet-borg/pull/44) ([bastelfreak](https://github.com/bastelfreak))

## [v1.1.1](https://github.com/voxpupuli/puppet-borg/tree/v1.1.1) (2019-10-22)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.1.0...v1.1.1)

**Fixed bugs:**

- centos: install missing dep perl-Test-MockObject [\#40](https://github.com/voxpupuli/puppet-borg/pull/40) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- simplify systemd timer setup [\#39](https://github.com/voxpupuli/puppet-borg/pull/39) ([bastelfreak](https://github.com/bastelfreak))

## [v1.1.0](https://github.com/voxpupuli/puppet-borg/tree/v1.1.0) (2019-09-03)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.0.1...v1.1.0)

**Implemented enhancements:**

- allow ssh port configuration [\#37](https://github.com/voxpupuli/puppet-borg/pull/37) ([deubert-it](https://github.com/deubert-it))

**Closed issues:**

- Add non-standard port configuration parameter for ssh config [\#36](https://github.com/voxpupuli/puppet-borg/issues/36)

## [v1.0.1](https://github.com/voxpupuli/puppet-borg/tree/v1.0.1) (2019-07-11)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/v1.0.0...v1.0.1)

**Fixed bugs:**

- vgcfgbackup: add support for multiple VGs [\#32](https://github.com/voxpupuli/puppet-borg/pull/32) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- allow puppetlabs/vcsrepo 3.x [\#33](https://github.com/voxpupuli/puppet-borg/pull/33) ([bastelfreak](https://github.com/bastelfreak))
- add `managed by puppet` header to templates [\#31](https://github.com/voxpupuli/puppet-borg/pull/31) ([bastelfreak](https://github.com/bastelfreak))

## [v1.0.0](https://github.com/voxpupuli/puppet-borg/tree/v1.0.0) (2019-06-17)

[Full Changelog](https://github.com/voxpupuli/puppet-borg/compare/494a35987e3936fca037eb6610d67acb0122905b...v1.0.0)

**Implemented enhancements:**

- backup lvm2 config if vgcfgbackup is present [\#28](https://github.com/voxpupuli/puppet-borg/pull/28) ([bastelfreak](https://github.com/bastelfreak))
- Add support for PPAs on Ubuntu 16.04 [\#26](https://github.com/voxpupuli/puppet-borg/pull/26) ([bastelfreak](https://github.com/bastelfreak))
- Implement support for custom exclude pattern [\#20](https://github.com/voxpupuli/puppet-borg/pull/20) ([bastelfreak](https://github.com/bastelfreak))
- Add Gentoo support [\#18](https://github.com/voxpupuli/puppet-borg/pull/18) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian 8/9 support [\#15](https://github.com/voxpupuli/puppet-borg/pull/15) ([bastelfreak](https://github.com/bastelfreak))
- Add support for custom root dir on remote storage [\#13](https://github.com/voxpupuli/puppet-borg/pull/13) ([bastelfreak](https://github.com/bastelfreak))
- Add Fedora support for the restore script [\#12](https://github.com/voxpupuli/puppet-borg/pull/12) ([bastelfreak](https://github.com/bastelfreak))
- update restore db after backuprun on Ubuntu [\#10](https://github.com/voxpupuli/puppet-borg/pull/10) ([bastelfreak](https://github.com/bastelfreak))
- Enable Ubuntu support for the restore script [\#5](https://github.com/voxpupuli/puppet-borg/pull/5) ([bastelfreak](https://github.com/bastelfreak))
- code cleanup; increase test coverage; update the restore DB after a backup run on CentOS [\#3](https://github.com/voxpupuli/puppet-borg/pull/3) ([bastelfreak](https://github.com/bastelfreak))
- enable BorgRestore support [\#2](https://github.com/voxpupuli/puppet-borg/pull/2) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Handle missing optional deps [\#16](https://github.com/voxpupuli/puppet-borg/issues/16)
- fix broken indentation [\#22](https://github.com/voxpupuli/puppet-borg/pull/22) ([bastelfreak](https://github.com/bastelfreak))
- Revert "Don't set `type=oneshot` for backup unit" [\#19](https://github.com/voxpupuli/puppet-borg/pull/19) ([bastelfreak](https://github.com/bastelfreak))
- \#16: execute opt-deps only if they are present [\#17](https://github.com/voxpupuli/puppet-borg/pull/17) ([bastelfreak](https://github.com/bastelfreak))
- fix wrong conditions in unit file [\#14](https://github.com/voxpupuli/puppet-borg/pull/14) ([bastelfreak](https://github.com/bastelfreak))
- Don't set `type=oneshot` for backup unit [\#11](https://github.com/voxpupuli/puppet-borg/pull/11) ([bastelfreak](https://github.com/bastelfreak))
- set correct $HOME for borg-restore.pl install [\#9](https://github.com/voxpupuli/puppet-borg/pull/9) ([bastelfreak](https://github.com/bastelfreak))
- install libdbd-sqlite3-perl on Ubuntu [\#8](https://github.com/voxpupuli/puppet-borg/pull/8) ([bastelfreak](https://github.com/bastelfreak))
- fix indentation in borg-backup.service [\#7](https://github.com/voxpupuli/puppet-borg/pull/7) ([bastelfreak](https://github.com/bastelfreak))
- set cache path in config [\#6](https://github.com/voxpupuli/puppet-borg/pull/6) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- allow saz/ssh 6.x [\#29](https://github.com/voxpupuli/puppet-borg/pull/29) ([bastelfreak](https://github.com/bastelfreak))
- Update documentation/README.md/metadata.json after repo migration [\#27](https://github.com/voxpupuli/puppet-borg/pull/27) ([bastelfreak](https://github.com/bastelfreak))
- allow puppetlabs/stdlib 5.x and 6.x; allow camptocamp/systemd 2.X,  allow saz/ssh 5.x [\#25](https://github.com/voxpupuli/puppet-borg/pull/25) ([bastelfreak](https://github.com/bastelfreak))
- allow Puppet 6.x in metadata.json [\#24](https://github.com/voxpupuli/puppet-borg/pull/24) ([bastelfreak](https://github.com/bastelfreak))
- add puppet-strings docs & generate REFERENCE.md [\#21](https://github.com/voxpupuli/puppet-borg/pull/21) ([bastelfreak](https://github.com/bastelfreak))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
