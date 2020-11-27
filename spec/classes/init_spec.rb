require 'spec_helper'

describe 'borg' do
  let :node do
    'rspec.puppet.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      let :params do
        {
          backupserver: 'localhost'
        }
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/backup-sh-conf.sh') }
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
          if facts[:os]['release']['major'] == '16.04'
            it { is_expected.to contain_apt__ppa('ppa:costamagnagianfranco/borgbackup') }
          end
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
      when 'Fedora'
        context 'on osfamily Fedora' do
          it { is_expected.to contain_package('perl-Path-Tiny') }
          it { is_expected.to contain_package('perl-Test-MockObject') }
          it { is_expected.to contain_package('perl-Test') }
          it { is_expected.to contain_package('perl-autodie') }
          it { is_expected.to contain_package('perl-App-cpanminus') }
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
    end
  end
end
