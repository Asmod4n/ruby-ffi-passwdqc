$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'passwdqc/version'

Gem::Specification.new do |gem|
  gem.author       = 'Hendrik Beskow'
  gem.description  = 'passwdqc, a password quality checker'
  gem.summary      = 'ruby ffi wrapper around http://www.openwall.com/passwdqc/'
  gem.homepage     = 'https://github.com/Asmod4n/ruby-ffi-passwdqc'
  gem.license      = 'Apache-2.0'

  gem.name         = 'ffi-passwdqc'
  gem.files        = Dir['README.md', 'LICENSE', 'lib/**/*']
  gem.version      = Passwdqc::VERSION

  gem.add_dependency 'ffi', '>= 1.9.6'
  gem.add_development_dependency 'bundler', '>= 1.7'
end
