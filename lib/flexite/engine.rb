module Flexite
  class Engine < ::Rails::Engine
    isolate_namespace Flexite

    initializer 'flexite.append_migrations' do |app|
      paths['db/migrate'].expanded.each do |migration|
        app.paths['db/migrate'] << migration
      end
    end

    config.generators do |g|
      g.template_engine :haml
    end

    config.autoload_paths << "#{config.root}/app/models/concerns"
  end
end
