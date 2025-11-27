require 'rack/protection'
use Rack::Protection, except: [:host_header, :host_authorization, :http_origin]

require './app'
run Sinatra::Application