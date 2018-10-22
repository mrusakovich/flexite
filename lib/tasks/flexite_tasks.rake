desc 'Base engine tasks'
namespace :flexite do
  task convert_yml: :environment do
    puts 'Converting....'
    result = Flexite::Data::NewService.new(Flexite::Data::Migrators::Yaml.new).call
    puts 'Finished'
    puts 'Errors:'

    result[:errors].each do |object, errors|
      puts "record: #{object.inspect}"

      errors.each do |error|
        puts "message: #{error.first}"
        puts "backtrace: #{error.last}"
      end

      puts '-' * 70
    end
  end

  task remove_settings: :environment do
    puts 'Removing....'
    Flexite::Config.transaction do
      Flexite::Config.delete_all
      Flexite::Entry.delete_all
    end
    puts 'Deleted'
  rescue StandartError => exc
    puts 'Smth went wrong...'
  end
end
