# Require the bundler gem and then call Bundler.require to load in all gems
# listed in Gemfile.
require 'bundler'
Bundler.require

# Setup DataMapper with a database URL. On Heroku, ENV['DATABASE_URL'] will be
# set, when working locally this line will fall back to using SQLite in the
# current directory.
DataMapper.setup(:default, ENV['DATABASE_URL']) || 'postgres://localhost/pg_default'

# Define a simple DataMapper model.
class Sensor
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :beacon, String, :length => 255
  property :temperature, Float
end

class Device
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :device, String, :length => 255
end

# Finalize the DataMapper models.
DataMapper.finalize

# Tell DataMapper to update the database according to the definitions above.
DataMapper.auto_upgrade!

#creates or updates a sensor
put '/sensor/:beacon/:temperature' do
	content_type :json

	puts params

	@sensor = Sensor.first_or_create(:beacon => params[:beacon])
end

#creates or updates a device and responds the temperature
put '/device/:device/:beacon' do
	content_type :json

	puts params

	#create device
	@device = Device.first_or_create(:device => params[:device])
	@sensor = Sensor.first_or_create(:beacon => params[:beacon])

	@sensor.temperature.to_json
end

get '/' do
  "Hello, world\n"
end

put '/location/:device/:beacon' do

end