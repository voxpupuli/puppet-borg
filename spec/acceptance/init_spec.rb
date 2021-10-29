# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'borg' do
  context 'with a backup server' do
    shell('sed -i "s/enabled=0/enabled=1/" /etc/yum.repos.d/CentOS-Linux-PowerTools.repo') if fact('os.name') == 'CentOS' && fact('os.release.major').to_i == 8
    let(:pp) do
      <<-PUPPET
      class { 'borg':
        backupserver      => 'localhost',
        manage_repository => false,
      }
      PUPPET
    end

    it 'works idempotently with no errors' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('borg-backup.timer') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe command('borg-restore.pl --version') do
      its(:stdout) { is_expected.to match(%r{^Version: 3.4.4$}) }
    end
  end

  context 'with a backup server and default repositry setup' do
    let(:pp) do
      <<-PUPPET
      class { 'borg':
        backupserver => 'localhost',
      }
      PUPPET
    end

    it 'works idempotently with no errors' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('borg-backup.timer') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'with a backup server and App:BorgRestore' do
    let(:pp) do
      <<-PUPPET
      class { 'borg':
        backupserver      => 'localhost',
        manage_repository => false,
        install_restore_script => true,
      }
      PUPPET
    end

    it 'works idempotently with no errors' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('borg-backup.timer') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe command('borg-restore.pl --version') do
      its(:stdout) { is_expected.to match(%r{^Version: 3.4.4$}) }
    end
  end
end
