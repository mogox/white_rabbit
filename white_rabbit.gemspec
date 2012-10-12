# -*- encoding: utf-8 -*-
require File.expand_path('../lib/white_rabbit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carlos Enrique Mogollan", "WellnessFX"]
  gem.email         = ["emogollan@gmail.com"]
  gem.description   = %q{This library lets you set a date and a time of a datetime attribute in a rails model}
  gem.summary       = %q{White Rabbit creates accessors for your datetime object so you can set the date and time and using datetime pickers in your views }
  gem.homepage      = "http://www.github.com/wellnessfx/white_rabbit"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "white_rabbit"
  gem.require_paths = ["lib"]
  gem.version       = WhiteRabbit::VERSION
end
