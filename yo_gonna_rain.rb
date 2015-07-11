require 'sinatra'
require 'json'
require 'faraday'
require 'slim'
require 'dotenv'
Dotenv.load

require_relative 'app/helpers'

configure { set :server, :puma }

FORECAST_API_KEY = ENV['FORECAST_API_KEY']
YO_KEY = ENV['YO_KEY']
ROOT_PATH = ENV['ROOT_PATH']

get '/yo/' do
  username = params['username']
  #TODO: Something if there is no location
  latitude, longitude = params['location'].split(';')
  
  post_res = Faraday.post 'https://api.justyo.co/yo/', {'api_token'=> YO_KEY, 'username'=>username, link: "#{ROOT_PATH}/gonna-rain/#{latitude}/#{longitude}"}
end

# Test Location
# LAT: 40.233844
# LONG: -111.659868
# localhost:4567/gonna-rain/40.233844/-111.659868
get '/gonna-rain/:lat/:long' do |lat, long|
  res = Faraday.get "https://api.forecast.io/forecast/#{FORECAST_API_KEY}/#{lat},#{long}"
  # TODO: What if this doesn't exist?? Need to fall back to hourly data. Also should we show a average possibility for rain? IDK
  json_data = JSON.parse(res.body)

  if json_data.key? 'minutely'
    @summary = json_data['minutely']['summary']
    icon = json_data['minutely']['icon']
  else
    @summary = json_data['hourly']['summary']
    icon = json_data['hourly']['icon']
  end

  @icon = iconify(icon)

  erb :index
end