# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem 'voxpupuli-test', git: 'https://github.com/voxpupuli/voxpupuli-test', branch: 'master',  :require => false
  gem 'coveralls',                 :require => false
  gem 'simplecov-console',         :require => false
  gem 'puppet-lint-param-docs',    :require => false
end

group :development do
  gem 'guard-rake',               :require => false
  gem 'overcommit', '>= 0.39.1',  :require => false
end

group :system_tests do
  gem 'puppet_metadata', '~> 1.0',  :require => false
  gem 'voxpupuli-acceptance',         :require => false
end

group :release do
  gem 'github_changelog_generator', '>= 1.16.1',  :require => false
  gem 'puppet-blacksmith',                        :require => false
  gem 'voxpupuli-release',                        :require => false
  gem 'puppet-strings', '>= 2.2',                 :require => false
end

gem 'puppetlabs_spec_helper', '>= 2', '< 4', :require => false
gem 'rake', :require => false
gem 'facter', ENV['FACTER_GEM_VERSION'], :require => false, :groups => [:test]

puppetversion = ENV['PUPPET_VERSION'] || '>= 6.0'
gem 'puppet', puppetversion, :require => false, :groups => [:test]

# vim: syntax=ruby
