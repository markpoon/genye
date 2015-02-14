require "sinatra/base"
require 'pathname'
require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite::memory:')
require_relative 'lib/objects.rb'

if settings.development?
  require 'sinatra/reloader'
  require 'benchmark'
  require 'pry'
end

class Application < Sinatra::Base 
  enable :inline_templates

  configure :development do
    Bundler.require(:development)
    register Sinatra::Reloader
    include Benchmark
    enable :logging
    get '/bind' do
      Binding.pry
    end
  end

  configure :production do
    Bundler.require(:production)
  end

  get '/' do
    slim :index
  end
end

DataMapper.finalize.auto_migrate!

path = Pathname.new("./public/snp/snp_short.txt")
u = User.create(name: "mark", email: "markpoon@me.com")
u.sequences << Sequence.parse(path)

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
