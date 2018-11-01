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
        it { is_expected.to contain_file('/usr/local/bin/borg-restore') }
        it { is_expected.to contain_file('/usr/local/bin/borg_exporter') }
        it { is_expected.to contain_class('borg::install')}
        it { is_expected.to contain_class('borg::config')}
        it { is_expected.to contain_class('borg::service')}
        it { is_expected.to contain_ssh__client__config__user('root_borg')}
        it { is_expected.to contain_borg__ssh_keygen('root_borg')}
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
        end
      end
    end
  end
end
