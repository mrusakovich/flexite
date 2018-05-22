module Flexite
  class Engine < ::Rails::Engine
    isolate_namespace Flexite

    config.before_configuration do |app|
      app.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
      app.config.assets.paths << File.join(root, 'app', 'assets', 'fonts')
    end

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
