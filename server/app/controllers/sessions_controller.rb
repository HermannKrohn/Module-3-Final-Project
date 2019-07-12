class SessionsController < ApplicationController

    def googleAuth
        # puts params["long"]
        access_token = nil
        refresh_token = nil
        id_token = nil
        parsedToken = nil
        userID = nil
        id_token_arr = nil
        id_token_body = nil
        decoded_token_body = nil
        parsed_decoded_token_body = nil
        mail_hash_arr = []
        payload = {
            code: params["code"],
            client_id: "247563481751-5v3guf2mir8tffh60n3k80trolcp7cid.apps.googleusercontent.com",
            client_secret: "4KQ5XPU_Y0ZarNOmeRFpiw7u",
            redirect_uri: "http://localhost:3000",
            grant_type: "authorization_code"
        }

        res_token = RestClient.post(
            'https://www.googleapis.com/oauth2/v4/token',
            payload,
            {'Content-Type': "application/x-www-form-urlencoded"}
        )

        parsedToken = JSON.parse(res_token.body)
        access_token = parsedToken["access_token"]
        refresh_token = parsedToken["refresh_token"]
        id_token = parsedToken["id_token"]
        id_token_arr = id_token.split(".")
        id_token_body = id_token_arr[1]
        decoded_token_body = Base64.decode64(id_token_body)
        parsed_decoded_token_body = JSON.parse(decoded_token_body)
        userID = parsed_decoded_token_body["sub"]
        
        # MESSAGES
        # message_list = RestClient::Request.execute(method: :get, url: "https://www.googleapis.com/gmail/v1/users/#{userID}/messages",
        #     headers: {"Authorization": "Bearer #{access_token}"})

        # parsed_message_list = JSON.parse(message_list)

        # parsed_message_list["messages"].each do |message_hash|
        #     current_msg_id = message_hash["id"]
        #     current_msg = RestClient::Request.execute(method: :get, url: "https://www.googleapis.com/gmail/v1/users/#{userID}/messages/#{current_msg_id}",
        #     headers: {"Authorization": "Bearer #{access_token}", Accept: "application/json"})
        #     parsed_current_msg = JSON.parse(current_msg.body)
        #     parsed_current_msg_headers = parsed_current_msg["payload"]["headers"]
        #     parsed_current_msg_headers.each do |hash|
        #         if hash["name"] == "Subject"
        #             current_msg_hash = {"subject" => hash["value"]}
        #             mail_hash_arr.push(current_msg_hash)
        #         end
        #     end
        #     puts "Message Added to Array"
        # end
        # puts "DONE CREATING MESSAGES"

        poi_res_JSON = RestClient.get "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{params['latitude']},#{params['longitude']}&radius=1500&type=restaurant&key=AIzaSyDZPgGlSIGXZmfNNkT7LoO8cr7joNMyqqo"
        parsed_POI = JSON.parse(poi_res_JSON) 
        byebug
        render json: parsed_POI["results"]

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
