puts 'Seeding database'
Flexite::Data::New.new(Flexite::Data::Migrators::Yaml.new({ app: ["#{Rails.root}/config/application.yml"] })).call
puts 'Finished'
