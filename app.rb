require 'pry'
require 'pathname'
require 'benchmark'
require_relative 'sequence'

use PryRescue::Rack if ENV["RACK_ENV"] == 'development'

class Application < Sinatra::Base 
  enable :inline_templates
  get '/' do
    slim :index
  end
  get '/bindings' do
    Binding.pry
  end
end

__END__
@@layout
doctype html
html
  head
    meta charset="utf-8"
    link rel="stylesheet" href="/stylesheets/style.css"
  body
    == yield
    
@@index
.center
| Hello World!
