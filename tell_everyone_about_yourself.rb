require 'sinatra'
require 'net/http'

get '/' do
  erb :index
end

get '/about' do
  content = "Hi All, In a hole in the ground there lived a hobbit. Not a nasty, dirty, wet hole, filled with the ends of worms and an oozy smell, nor yet a dry, bare, sandy hole with nothing in it to sit down on or to eat: it was a hobbit-hole, and that means comfort."
  channel = '/about'
  
  message = { channel: channel, data: content, ext: {auth_token: 'secret'}}
  uri = URI.parse('http://localhost:8080/faye')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data(message: message.to_json)
  http.request(request)

  puts "broacasting to the about channel"
  erb :about
end