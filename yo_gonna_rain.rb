require 'sinatra'
require 'json'
require 'faraday'
require 'slim'
require 'dotenv'
Dotenv.load

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

get '/gonna-rain/:lat/:long' do |lat, long|
  res = Faraday.get "https://api.forecast.io/forecast/#{FORECAST_API_KEY}/#{lat},#{long}"
  # TODO: What if this doesn't exist?? Need to fall back to hourly data. Also should we show a average possibility for rain? IDK
  json_data = JSON.parse(res.body)
  if json_data.key? 'minutely'
    summary = json_data['minutely']['summary']
  else
    summary = json_data['hourly']['summary']
  end
  slim :gonna_rain, locals: {weather: summary}
end

__END__

@@ gonna_rain
html
  head
    title YOGONNARAIN
    css:
      @import url(https://fonts.googleapis.com/css?family=Montserrat:400,700);
      body {
        background-color: #9B59B6;
        line-height: 89px;
      }
      h1 {
        color: #FFFFFF;
        font-family: Montserrat;
        font-weight: bold;
        font-size: 89px;
      }
  body
    center
      h1 =weather