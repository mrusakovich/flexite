puts 'Seeding database'
Flexite::Data::New.new(Flexite::Data::Migrators::Yaml.new).call
puts 'Finished'
