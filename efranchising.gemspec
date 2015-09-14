# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'efranchising/version'

Gem::Specification.new do |spec|
  spec.name          = "efranchising"
  spec.version       = Efranchising::VERSION
  spec.authors       = ["Eduardo Alencar"]
  spec.email         = ["lebas66@gmail.com"]

  spec.summary       = %q{Ecommerce}
  spec.description   = %q{Ecommerce for franchising}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'bullet'
  spec.add_development_dependency 'factory_girl_rails', '~> 4.4.1'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry-rails' 

  spec.add_dependency 'jquery-ui-rails'
#  spec.add_dependency 'sass-rails'
#  spec.add_dependency 'uglifier'
#  spec.add_dependency 'activemerchant'
#  spec.add_dependency 'ruby_parser'
#  spec.add_dependency 'haml'
#  spec.add_dependency 'acts_as_list'
#  spec.add_dependency 'nested_set'
#  spec.add_dependency 'paperclip'
#  spec.add_dependency 'rails3-jquery-autocomplete'
#  spec.add_dependency 'client_side_validations'
#  spec.add_dependency 'acts-as-taggable-on'
#  spec.add_dependency 'httpclient'
#  spec.add_dependency 'parseline'
#  spec.add_dependency 'twitter_oauth'
#  spec.add_dependency 'wicked_pdf'
#  spec.add_dependency 'wkhtmltopdf-binary'
#  spec.add_dependency 'bcrypt-ruby'
#  spec.add_dependency 'devise'
#  spec.add_dependency 'devise-encryptable'
#  spec.add_dependency 'omniauth-facebook'
#  spec.add_dependency 'delayed_job_active_record'
#  spec.add_dependency 'brazilian-rails'
#  spec.add_dependency 'json'
#  spec.add_dependency 'brcobranca'
#  spec.add_dependency 'boletorb'
#  spec.add_dependency 'instagram'
#  spec.add_dependency 'nokogiri'
#  spec.add_dependency 'gmaps4rails'
#  spec.add_dependency 'geokit-rails'
#  spec.add_dependency 'certified'
#  spec.add_dependency 'polyamorous'
#  spec.add_dependency 'railties'
  #spec.add_dependency 'activeadmin', '~> 1.0.0.pre1'
#  spec.add_dependency 'kaminari'

  #spec.add_dependency 'userstamp'
  #spec.add_dependency 'icheck-rails'

end
