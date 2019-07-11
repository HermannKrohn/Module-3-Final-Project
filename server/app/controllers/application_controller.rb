require 'rest-client'
require 'base64'
class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
end
