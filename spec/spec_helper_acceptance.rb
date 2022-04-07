# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_module_from_forge_on(host, 'puppet-archive'.dup, '>= 4.6.0 < 7.0.0'.dup)
  case fact_on(host, 'os.family')
  when 'Debian'
    install_module_from_forge_on(host, 'puppetlabs-apt'.dup, '>= 4.1.0 < 9.0.0'.dup)
  when 'RedHat'
    install_package(host, 'epel-release')
  end
end
