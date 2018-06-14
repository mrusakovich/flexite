desc 'Base engine tasks'
namespace :flexite do
  task convert_yml: :environment do
    puts 'Converting....'
    result = Flexite::Data::New.new(Flexite::Data::Migrators::Yaml.new).call
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
end
