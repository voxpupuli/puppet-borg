# frozen_string_literal: true

require 'spec_helper'
command_output = 'borg 1.1.16'
fact_output = { 'version' => '1.1.16' }
describe Facter::Util::Fact.to_s do
  before { Facter.clear }

  context 'borg not in path' do
    before do
      allow(Facter::Util::Resolution).to receive(:which).with('borg').and_return(nil)
    end

    it { expect(Facter.fact(:borgbackup).value).to eq(nil) }
  end

  context 'valid run' do
    before do
      allow(Facter::Util::Resolution).to receive(:which).with('borg').and_return('/usr/bin/borg')
    end

    context 'borgbackup version' do
      before do
        allow(Facter::Util::Resolution).to receive(:exec).with('borg --version') { command_output }
      end

      it { expect(Facter.fact(:borgbackup).value).to eq fact_output }
    end
  end
end
