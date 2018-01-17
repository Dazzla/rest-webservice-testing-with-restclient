require_relative '../specs/spec_helper'

RSpec.describe('Users') do

  #TODO: This spec could be better. Needs to be tidied to reduce repetition

  let :user_fields do
    [:id, :first_name, :last_name, :avatar]
  end

  describe 'list_users' do

    let :url do
      BASE_URL + '/users/?page=1'
    end

    it 'retrieves the user list' do
      response = RestClient.get(url)
      response_body = JSON.parse(response)
      expect(response.code).to eq 200
      expect(response_body.has_key? 'data')
      expect(response_body['data'][0].length).to be > 1
      user_fields.each do |field|
        expect(response_body['data'][0].has_key? field)
      end
    end
  end

  describe 'retrieve single user' do
    let :url do
      BASE_URL + '/users/2'
    end

    it 'retrieves a single user' do
      response = RestClient.get(url)
      response_body = JSON.parse(response)
      expect(response.code).to eq 200
      expect(response_body.has_key? 'data')
      user_fields.each do |field|
        expect(response_body.has_key? field)
      end
    end
  end

  describe 'single user not found' do
    let :url do
      BASE_URL + '/users/2888'
    end

    it 'returns an error for a non-existent user record' do
      RestClient.get(url) do |response, request, result|
        expect(response.code).to eq 404
        expect(response.empty?)
      end

    end


  end


end