$: << File.join(File.dirname(__FILE__), 'lib')
require 'sinatra'
require "sinatra/reloader" if development?
require 'haml'
require 'lyrica/lyrica'

set :root, File.dirname(__FILE__)

configure do
  set :haml, :format => :html5
  DATA_DIR = File.expand_path(File.join(File.dirname(__FILE__), 'data'))
end

before do
  @lyrica = Lyrica.new
end

get '/' do
  charts = @lyrica.artists
  haml :index, :locals => { :charts => charts, :title => 'lyrica' }
end

get '/reload' do
  @lyrica.load!(DATA_DIR, true)
  'Reloading'
end

get '/view/:filename' do |filename|
  chart = @lyrica.charts(:filename => filename).first
  not_found if chart.count < 1
  haml :view, :locals => { :chart => chart, :title => chart[:title] + ' // ' + chart[:artist] }
end

get '/all' do
  songs = @lyrica.charts
  not_found if songs.count < 1
  haml :list, :locals => { :songs => songs, :title => 'all songs' }
end

get '/:artist' do |artist|
  songs = @lyrica.charts(:artist => artist)
  not_found if songs.count < 1
  haml :list, :locals => { :songs => songs, :title => artist }
end

not_found do
  'Oh no!'
end