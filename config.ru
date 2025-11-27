# config.ru

require 'sinatra' 

# Use o middleware Rack::Protection e desative os módulos que conflitam com o Fly.io
use Rack::Protection, except: [:host_header, :host_authorization, :http_origin, :remote_token] 

# Carrega seu código Sinatra (assumindo que está em app.rb)
require './app' 

run Sinatra::Application