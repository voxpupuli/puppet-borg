# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_puppet_module_via_pmt_on(host, 'puppet-archive')
  case fact_on(host, 'os.family')
  when 'Debian'
    install_puppet_module_via_pmt_on(host, 'puppetlabs-apt')
  when 'RedHat'
    install_package(host, 'epel-release')
  end
end
