Gem::Specification.new do |gem|
  gem.name    = 'ticket_technology'
  gem.version = '0.0.1'
  gem.summary = 'An interface library for the Ticket Technology web service.'

  gem.files = Dir['lib/**/*']
  gem.add_dependency 'activesupport', '>= 3.0.0.beta4'
  gem.add_dependency 'tzinfo',        '>= 0.3.22'
  gem.add_dependency 'i18n',          '>= 0.4.1'
  gem.add_dependency 'patron',        '0.4.6'
  gem.add_dependency 'sax-machine',   '0.0.15'
end
