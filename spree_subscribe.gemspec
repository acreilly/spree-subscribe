# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_subscribe'
  s.version     = '0.3.4'
  s.summary     = ''
  s.description = ''
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Allison Reilly'
  s.email     = 'allison@railsdog.com'
  s.homepage  = 'http://www.allisoncreilly.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.3.0'
  s.add_dependency 'spree_backend', '~> 2.3.0'
  s.add_dependency 'spree_frontend', '~> 2.3.0'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'rspec-its', '~> 1.0'
  s.add_development_dependency 'shoulda-matchers', '~> 2.7'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'guard-rspec'
end
