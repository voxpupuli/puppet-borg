require 'spec_helper_acceptance'

describe 'borg' do
  context 'with a backup server' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      if ( $facts['os']['family'] == 'RedHat') {
        package{'epel-release':
          ensure => 'present',
          before => Class['borg'],
        }
      }
      class{'borg':
        backupserver => 'localhost',
        manage_repository => false,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
