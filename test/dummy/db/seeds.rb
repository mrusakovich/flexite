puts 'Seeding database'
Flexite::Data::NewService.new(Flexite::Data::Migrators::Yaml.new).call
puts 'Finished'
