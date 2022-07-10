# frozen_string_literal: true

Facter.add(:borgbackup) do
  confine do
    Facter::Util::Resolution.which('borg')
  end
  setcode do
    version = Facter::Util::Resolution.exec('borg --version').split.last
    { 'version' => version }
  end
end
