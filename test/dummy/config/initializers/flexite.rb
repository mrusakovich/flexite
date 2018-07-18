Flexite.configure do |c|
  c.paths = {
    app: ["#{Rails.root}/config/application.yml"]
  }
  c.app_name = 'Dummy'
  c.migration_token = 'test'
  c.stages = [
    ['Dummy1', 'http://localhost:8000']
  ]
  c.stagename = 'Dummy'
end
