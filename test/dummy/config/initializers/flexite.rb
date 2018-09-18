Flexite.configure do |c|
  c.paths = {
    app: ["#{Rails.root}/config/application.yml"]
  }
  c.app_name = 'Dummy'
  c.migration_token = 'test'
  c.stages = [
    ['test-app', 'http://localhost:8080']
  ]
  c.stagename = 'Dummy'
end
