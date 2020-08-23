require "spec_helper"

module SomlengAdhearsion
  module Web
    RSpec.describe Application, :web_application do
      let(:app) { Application.new }

      it "requires basic authentication" do
        basic_authorize "username", "wrong-password"

        post "/calls"

        expect(last_response.status).to eq(401)
      end

      describe "POST /calls" do
        it "initiates an outbound call" do
          basic_authorize "username", "password"
          post(
            "/calls",
            {
              "to" => "+85512334667",
              "from" => "2442",
              "voice_url" => "https://rapidpro.ngrok.com/handle/33/",
              "voice_method" => "GET",
              "status_callback_url" => "https://rapidpro.ngrok.com/handle/33/",
              "status_callback_method" => "POST",
              "sid" => "sample-call-sid",
              "account_sid" => "sample-account-sid",
              "account_auth_token" => "sample-auth-token",
              "direction" => "outbound-api",
              "api_version" => "2010-04-01",
              "routing_instructions" => {
                "source" => "2442",
                "destination" => "+85512334667",
                "dial_string" => "85512334667@127.0.0.1"
              }
            }.to_json,
            {
              "CONTENT_TYPE" => "application/json"
            }
          )

          expect(last_response.status).to eq(200)
          expect(json_response["id"]).not_to be_empty
        end
      end
    end
  end
end
