#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'
Bundler.require

ROOT_PATH = File.expand_path(File.dirname(__FILE__))

if ENV['DEBUG'] == 'yes'
 ENV['APP_TYPE'] = 'rhosync'
 ENV['ROOT_PATH'] = ROOT_PATH
 require 'debugger'
end

# Try to load vendor-ed rhoconnect, otherwise load the gem
begin
  require 'vendor/rhoconnect/lib/rhoconnect/server'
  require 'vendor/rhoconnect/lib/rhoconnect/console/server'
rescue LoadError
  require 'rhoconnect/server'
  require 'rhoconnect/console/server'
end

# By default, turn on the resque web console
require 'resque/server'


# Rhoconnect server flags
Rhoconnect::Server.disable :run
Rhoconnect::Server.disable :clean_trace
Rhoconnect::Server.enable  :raise_errors
Rhoconnect::Server.set     :secret,      'f1ad1da70ac7471be946ac05079024c828db289be28038b405d27dcfa15eb88b591791ee58cfb4b39b7032b0a1c9112e3b5fecd4648e327689a37df6c253a7ed'
Rhoconnect::Server.set     :root,        ROOT_PATH
Rhoconnect::Server.use     Rack::Static, :urls => ["/data"], :root => Rhoconnect::Server.root

# Load our rhoconnect application
$:.unshift ROOT_PATH if RUBY_VERSION =~ /1.9/ # FIXME: see PT story #16682771
require 'application'

# Setup the url map
run Rack::URLMap.new \
	"/"         => Rhoconnect::Server.new,
	"/resque"   => Resque::Server.new, # If you don't want resque frontend, disable it here
	"/console"  => RhoconnectConsole::Server.new # If you don't want rhoconnect frontend, disable it here