Flexite.configure do |c|
  c.paths = {
    app: ["#{Rails.root}/config/application.yml"]
  }
  c.app_name = 'Dummy'
end
