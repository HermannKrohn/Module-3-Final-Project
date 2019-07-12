class SessionsController < ApplicationController

    def googleAuth
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
        
        # message_list = RestClient::Request.execute(method: :get, url: "https://www.googleapis.com/gmail/v1/users/#{userID}/messages",
        #     headers: {"Authorization": "Bearer #{access_token}"})

        # parsed_message_list = JSON.parse(message_list)

        # parsed_message_list["messages"].each do |message_hash|
        #     current_msg_id = message_hash["id"]
        #     current_msg = RestClient::Request.execute(method: :get, url: "https://www.googleapis.com/gmail/v1/users/#{userID}/messages/#{current_msg_id}",
        #     headers: {"Authorization": "Bearer #{access_token}", Accept: "application/json"})
        #     parsed_current_msg = JSON.parse(current_msg.body)
        #     parsed_current_msg_headers = parsed_current_msg["payload"]["headers"]
        #     current_msg_hash = {"sender" => "N/A", "subject" => "N/A"}
        #     parsed_current_msg_headers.each do |hash|
        #         if hash["name"] == "From"
        #             sender_name_arr = hash["value"].split("<")
        #             current_msg_hash["sender"] = sender_name_arr[0]
        #         elsif hash["name"] == "Subject"
        #             current_msg_hash["subject"] = hash["value"]
        #         end
        #     end
        #     mail_hash_arr.push(current_msg_hash)
        #     puts "Message Added to Array"
        # end
        # puts "DONE CREATING MESSAGES"

        calendar_list = RestClient::Request.execute(method: :get, url: "https://www.googleapis.com/calendar/v3/users/me/calendarList",
            headers: {"Authorization": "Bearer #{access_token}"})

        parsed_calendar_list = JSON.parse(calendar_list.body)["items"]
        calendar_id = nil
        all_calendar_events = []
        calendar_events = parsed_calendar_list.map do |calendar|
            begin
                calendar_id = calendar["id"]
                current_calendar_event = RestClient::Request.execute(method: :get, url: "https://www.googleapis.com/calendar/v3/calendars/#{calendar_id}/events",
                    headers: {"Authorization": "Bearer #{access_token}"})
                parsed_current_calendar_event = JSON.parse(current_calendar_event)
                all_calendar_events.push(parsed_current_calendar_event)
            rescue Exception => e
            end
        end
        all_calendar_events = all_calendar_events[0]["items"]
        upcoming_events_only_arr = []
        all_calendar_events.each do |event_hash|
            begin
                date_string = event_hash["start"]["dateTime"]
                date_string_arr = date_string.split("T")
                event_date = Date.strptime(date_string_arr[0], "%Y-%m-%d")
                current_date = Date.strptime(Time.now.to_s.split(" ")[0], "%Y-%m-%d")
                if event_date >= current_date
                    upcoming_events_only_arr.push(event_hash)
                end
            rescue Exception => e
            end
        end

        poi_res_json = RestClient.get "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{params['latitude']},#{params['longitude']}&radius=1500&type=restaurant&key=AIzaSyDZPgGlSIGXZmfNNkT7LoO8cr7joNMyqqo"
        parsed_POI_json = JSON.parse(poi_res_json) 
        parsed_POI_arr = parsed_POI_json["results"]

        output_hash = {
            "emails" => mail_hash_arr,
            "calendar_events" => upcoming_events_only_arr,
            "POIs" => parsed_POI_arr
        }
        render json: output_hash
    end

    # def test
    #     puts ("JSONNNNNN")
    # end
end
