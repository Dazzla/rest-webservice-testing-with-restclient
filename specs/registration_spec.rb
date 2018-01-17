require_relative 'spec_helper'

RSpec.describe('Registration and Authentication') do

  describe 'registration' do

    let :url do
      BASE_URL + '/register'
    end

    let :post_body do
      {
          'email': 'sydney@fife',
          'password': 'pistol'
      }
    end

    it 'registers successfully' do

      RestClient.post(url, post_body) do |response, request, result|
        response_body = JSON.parse(response)
        expect(response.code).to eq 201
        expect(response_body.has_key?('token'))
      end

    end

    it 'registers unsuccessfully' do
      RestClient.post(url, post_body.delete('password')) do |response, request, result|
        expect(response).to eq '{"error":"Missing email or username"}'
      end
    end

    describe 'log in' do

      let :url do
        BASE_URL + '/login'
      end

      let :successful_login_post do
        {
            "email": "test@example.com",
            "password": "*********"
        }
      end

      let :unsuccessful_login_post do
        {
            "password": "*********"
        }
      end

      it 'logs in successfully' do
        RestClient.post(url, successful_login_post) do |response, request, result|
          expect(response.code).to eq 200
          response_body = JSON.parse(response)
          expect(response_body.has_key?('token'))
        end
      end

      it 'fails to log in' do
        RestClient.post(url, unsuccessful_login_post) do |response, request, result|
          response_body = JSON.parse(response)
          expect(response.code).to eq 400
          expect(response_body.has_key?('token'))
          expect(response).to eq '{"error":"Missing email or username"}'
        end
      end

    end

  end



end