# require 'rest-client'

class SessionsController < ApplicationController

    def googleAuth
        access_token = nil
        refresh_token = nil
        id_token = nil
        parsedToken = nil
        puts "got inside of googleAuth method"
        payload = {
            code: params["code"],
            client_id: "247563481751-5v3guf2mir8tffh60n3k80trolcp7cid.apps.googleusercontent.com",
            client_secret: "4KQ5XPU_Y0ZarNOmeRFpiw7u",
            redirect_uri: "http://localhost:3000",
            grant_type: "authorization_code"
        }
        begin
            res_token = RestClient.post(
                'https://www.googleapis.com/oauth2/v4/token',
                payload,
                {'Content-Type': "application/x-www-form-urlencoded"}
            )
        rescue Exception => e
            # byebug
        end
        # byebug
        # Get access tokens from the google server
        # access_token = request.env["omniauth.auth"]
        puts access_token
        parsedToken = JSON.parse(res_token.body)
        access_token = parsedToken["access_token"]
        refresh_token = parsedToken["refresh_token"]
        id_token = parsedToken["id_token"]
        # message_list = RestClient.get(
        #     "https://www.googleapis.com/gmail/v1/users/#{id_token}/messages",
        #     {"Authorization": "Bearer #{access_token}"}
        # )
        begin
        message_list = RestClient::Request.execute(method: :get, url: "https://www.googleapis.com/gmail/v1/users/USERID/messages",
            headers: {"Authorization": "Bearer #{access_token}"})
        rescue Exception => e
            byebug
        end
        # EventsController.get_calendars(access_token, refresh_token)
        byebug
        # user = User.from_omniauth(parsed_token)
        # log_in(user)
        # Access_token is used to authenticate request made from the rails application to the google server
        # user.google_token = access_token.credentials.token
        # Refresh_token to request new access_token
        # Note: Refresh_token is only sent once during the first request
        # refresh_token = access_token.credentials.refresh_token
        # user.google_refresh_token = refresh_token if refresh_token.present?
        # user.save
        # redirect_to root_path
    end

    def code 
        puts params
    end

    def test
        puts ("JSONNNNNN")
    end
end
