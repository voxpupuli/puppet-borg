# frozen_string_literal: true

Facter.add(:borgbackup) do
  confine do
    Facter::Core::Execution.which('borg')
  end
  setcode do
    version = Facter::Core::Execution.execute('borg --version').split.last
    { 'version' => version }
  end
end
