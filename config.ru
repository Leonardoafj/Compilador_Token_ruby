require 'rack/protection'
use Rack::Protection, except: [:host_header, :host_authorization, :http_origin, :remote_token]

require './app'
run Sinatra::Application