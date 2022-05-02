#Use bundler to load gems
require 'bundler'

require 'net/http'

#Load gems from Gemfile
Bundler.require

use Rack::MethodOverride

#Load the app
require_relative 'calculations.rb'
require_relative 'main.rb'

#Run the application
run Main
