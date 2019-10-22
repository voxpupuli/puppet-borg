# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

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
