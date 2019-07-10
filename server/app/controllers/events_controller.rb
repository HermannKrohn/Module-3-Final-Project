require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
class EventsController < ApplicationController

    private
    def self.google_secret(access_token, refresh_token)
        puts "gS"
        Google::APIClient::ClientSecrets.new(
        { "web" =>
            { "access_token" => access_token,
            "refresh_token" => refresh_token,
            "client_id" =>ENV['GOOGLE_CLIENT_ID'],
            "client_secret" => ENV['GOOGLE_CLIENT_SECRET'],
            }
        }
        )
    end


    def self.get_calendars(access_token, refresh_token)
        puts "calendar"
        # Initialize Google Calendar API
        service = Google::Apis::CalendarV3::CalendarService.new
        # Use google keys to authorize
        service.authorization = self.google_secret(access_token, refresh_token).to_authorization
        # Request for a new aceess token just incase it expired
        service.authorization.refresh!
        # Get a list of calendars
        calendar_list = service.list_calendar_lists.items
            calendar_list.each do |calendar|
            puts calendar
        end
    end
end
