require 'spec_helper_acceptance'

describe 'borg' do
  context 'with a backup server' do
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
  end
end
