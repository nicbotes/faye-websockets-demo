require 'rubygems'
require 'bundler'
Bundler.require
require 'faye'

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != 'secret'
        message['error'] = 'Invalid authentication token'
      end
    end
    puts "incoming: #{message}"
    callback.call(message)
  end

  def outgoing(message, callback)
    if message['ext'] && message['ext']['auth_token']
      message['ext'] = {}
    end
    puts "outgoing: #{message}"
    callback.call(message)
  end
end
Faye::WebSocket.load_adapter('thin')
faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45, :ping => 3)
faye_server.add_extension(ServerAuth.new)
run faye_server
