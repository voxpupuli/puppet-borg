require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_module_from_forge_on(host, 'puppet-archive', '>= 4.6.0 < 7.0.0')
  case fact_on(host, 'os.family')
  when 'Debian'
    install_module_from_forge_on(host, 'puppetlabs-apt', '>= 4.1.0 < 9.0.0')
  when 'RedHat'
    install_package(host, 'epel-release') unless fact_on(host, 'os.name') == 'Fedora'
  end
end
