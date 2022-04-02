# frozen_string_literal: true

require 'spec_helper'

describe 'borg' do
  let :node do
    'rspec.puppet.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts.merge({ systemd: true })
      end

      let :params do
        {
          backupserver: 'localhost'
        }
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/borg') }
        it { is_expected.to contain_file('/etc/profile.d/borg.sh') }
        it { is_expected.to contain_file('/usr/local/bin/borg-backup') }
        it { is_expected.to contain_file('/usr/local/bin/borg_exporter') }
        it { is_expected.to contain_file('/etc/borg-restore.cfg') }
        it { is_expected.to contain_class('borg::install') }
        it { is_expected.to contain_class('borg::config') }
        it { is_expected.to contain_class('borg::service') }
        it { is_expected.to contain_ssh__client__config__user('root') }
        it { is_expected.to contain_ssh_keygen('root_borg') }
        it { is_expected.to contain_exec('ssh_keygen-root_borg') }
        it { is_expected.to contain_systemd__unit_file('borg-backup.timer') }
        it { is_expected.to contain_systemd__unit_file('borg-backup.service').without_content(%r{Requires=}) }
        it { is_expected.to contain_systemd__unit_file('borg-backup.service').with_content(%r{Wants=network-online.target}) }
        it { is_expected.to contain_systemd__unit_file('borg-backup.service').with_content(%r{After=network-online.target}) }
      end

      context 'with requires and no wants/after dependencies' do
        let :params do
          {
            requires: ['foo'],
            wants: [],
            after: [],
            backupserver: 'localhost',
          }
        end

        it { is_expected.to contain_systemd__unit_file('borg-backup.service').with_content(%r{Requires=foo}) }
        it { is_expected.to contain_systemd__unit_file('borg-backup.service').without_content(%r{Wants=}) }
        it { is_expected.to contain_systemd__unit_file('borg-backup.service').without_content(%r{After=}) }
      end

      case facts[:os]['name']
      when 'Archlinux'
        context 'on Archlinux' do
          it { is_expected.to contain_package('borg') }
          it { is_expected.to contain_package('perl-app-borgrestore') }
        end
      when 'Ubuntu'
        context 'on Ubuntu' do
          it { is_expected.to contain_package('borgbackup') }
          it { is_expected.to contain_package('borgbackup-doc') }
          it { is_expected.to contain_package('gcc') }
          it { is_expected.to contain_package('make') }
          it { is_expected.to contain_package('cpanminus') }
          it { is_expected.to contain_package('libdbd-sqlite3-perl') }

          it { is_expected.to contain_apt__ppa('ppa:costamagnagianfranco/borgbackup') } if facts[:os]['release']['major'] == '16.04'
        end
      when 'RedHat', 'CentOS'
        context 'on osfamily Redhat' do
          it { is_expected.to contain_package('gcc') }
          it { is_expected.to contain_package('perl-core') }
          it { is_expected.to contain_exec('install_borg_restore') }
          it { is_expected.to contain_file('/opt/BorgRestore') }
          it { is_expected.to contain_file('/usr/local/bin/borg-restore.pl') }

          if facts[:os]['release']['major'].to_i == 8
            it { is_expected.not_to contain_package('perl-TAP-Harness-Env') }
            it { is_expected.to contain_package('perl-App-cpanminus') }
          else
            it { is_expected.to contain_package('perl-TAP-Harness-Env') }
            it { is_expected.not_to contain_package('perl-App-cpanminus') }
          end
        end
      when 'Gentoo'
        context 'on osfamily Gentoo' do
          it { is_expected.to contain_package('App-cpanminus') }
        end
      end

      context 'with keep intervall set to 0' do
        let :params do
          {
            keep_yearly: 0,
            keep_monthly: 0,
            keep_weekly: 0,
            keep_daily: 0,
            keep_within: 0,
            backupserver: 'localhost'
          }
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'fails without backupserver' do
        let :params do
          {}
        end

        it { is_expected.not_to compile }
      end

      context 'without manage_package' do
        let :params do
          {
            backupserver: 'localhost',
            manage_package: false
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_package('borgbackup') }
      end

      context 'with ssh_key_type set to rsa' do
        let :params do
          {
            backupserver: 'localhost',
            ssh_key_type: 'rsa'
          }
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'fails without a valid backuptime present' do
        let :params do
          {
            backupserver: 'localhost',
            backuptime: ''
          }
        end

        it { is_expected.not_to compile }
      end

      context 'with nondefault backuptime present' do
        let :params do
          {
            backupserver: 'localhost',
            backuptime: { 'default' => '01:00:00' }
          }
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'with multiple backuptimes present' do
        let :params do
          {
            backupserver: 'localhost',
            backuptime: { '1 am' => '01:00:00', '2 am' => '02:00:00' }
          }
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'without nondefault compression present' do
        let :params do
          {
            backupserver: 'localhost',
            compression: 'auto,zstd,6'
          }
        end

        it { is_expected.to contain_file('/usr/local/bin/borg-backup').with_content(%r{^\s+--compression "auto,zstd,6"$}) }
      end

      context 'without manage_prune' do
        let :params do
          {
            backupserver: 'localhost',
            manage_prune: false
          }
        end

        it { is_expected.not_to contain_file('/usr/local/bin/borg-backup').with_content(%r{/^\s+borg prune/}) }
      end

      context 'with absolute backup destination dir present' do
        let :params do
          {
            backupserver: 'localhost',
            create_prometheus_metrics: true,
            absolutebackupdestdir: '/some/other/path'
          }
        end

        it { is_expected.to contain_file('/etc/borg').with_content(%r{^REPOSITORY=backup:/some/other/path$}) }
        it { is_expected.to contain_file('/etc/profile.d/borg.sh').with_content(%r{^export BORG_REPO=backup:/some/other/path$}) }
        it { is_expected.to contain_file('/usr/local/bin/borg-backup').with_content(%r{\s*borg_repo="backup:/some/other/path"$}) }
      end

      context 'with additional excludes' do
        let :params do
          {
            backupserver: 'localhost',
            additional_excludes: ['/path with/spaces']
          }
        end

        it { is_expected.to contain_file('/usr/local/bin/borg-backup').with_content(%r{^"/path with/spaces"$}) }
      end

      context 'without exclude_pattern' do
        let :params do
          {
            backupserver: 'localhost',
            exclude_pattern: ['sh:/some/path/*']
          }
        end

        it { is_expected.to contain_file('/usr/local/bin/borg-backup').with_content(%r{^sh:/some/path/\*$}) }
      end
    end
  end
end
