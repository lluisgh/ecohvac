# Require the bundler gem and then call Bundler.require to load in all gems
# listed in Gemfile.
require 'bundler'
require 'pp'
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

# Finalize the DataMapper models.
DataMapper.finalize

# Tell DataMapper to update the database according to the definitions above.
DataMapper.auto_upgrade!


put '/sensor' do
	content_type :json

	pp params

	@sensor = Sensor.first_or_new(:beacon => params[:beacon])
	@sensor.temperature = params[:temperature]

	if @sensor.save
    	@sensor.to_json
 	else
    	halt 404
  	end
end

get '/' do
  "Hello, world\n"
end

put '/location/:device/:beacon' do

end