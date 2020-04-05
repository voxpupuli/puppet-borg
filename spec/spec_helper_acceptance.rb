require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'


RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    install_module
    install_module_dependencies

    # Install aditional modules for soft deps
    hosts.each do |host|
      case fact_on(host, 'os.family')
      when 'Debian'
        install_module_from_forge_on(host, 'puppetlabs-apt', '>= 4.1.0 < 8.0.0')
      when 'RedHat'
        host.install_package('epel-release')
      end
    end
  end
end
