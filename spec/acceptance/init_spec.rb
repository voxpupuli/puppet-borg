require 'spec_helper_acceptance'

describe 'borg' do
  context 'with a backup server' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      package{'epel-release':
        ensure => 'present',
        }
      -> class{'borg':
        backupserver => 'localhost',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
