require_relative '../specs/spec_helper'

RSpec.describe('Users') do

  #TODO: This spec could be better. Needs to be tidied to reduce repetition and improve readability
  #TODO: Mock service

  let :user_fields do
    [:id, :first_name, :last_name, :avatar]
  end

  describe 'list_users' do

    let :url do
      BASE_URL + '/users/?page=2'
    end

    it 'retrieves the user list' do
      response = RestClient.get(url)
      response_body = JSON.parse(response)
      expect(response.code).to eq 200
      expect(response_body.has_key? 'data')
      expect(response_body['page']).to eq 2
      expect(response_body['data'][0].length).to be > 1
      user_fields.each do |field|
        expect(response_body['data'][0].has_key? field)
      end
    end

    it 'returns users with a delay' do
      url = BASE_URL + '/users?delay=3'
      response = RestClient.get(url)
      response_body = JSON.parse(response)
      expect(response.code).to eq 200
      expect(response_body.has_key? 'data')
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
      RestClient.get(url) do |response|
        expect(response.code).to eq 404
        expect(response.empty?)
      end
    end

  end

  context 'create, update, patch, delete' do
    let :url do
      BASE_URL + '/users'
    end

    describe 'create user' do

      let :post_body do
        {
            'name': "test_user_#{rand((10)*1000).round(0)}",
            'job': 'leader'
        }
      end

      it 'successfully creates a user' do
        RestClient.post(url, post_body) do |response|
          expect(response.code).to eq 201
          response_body = JSON.parse(response.body)
          expect(response_body['name']).to match /test_user_\d+/
          #TODO: add createdAt check
        end
      end

    end

    describe 'patch and update user' do
      let :post_body do
        {
            'name': "test_user_#{rand((10)*1000).round(0)}",
            'job': 'UPDATE'
        }
      end

      it 'put updates a user record' do
        response = RestClient.post(url, post_body)
        response_body = JSON.parse(response)
        RestClient.put(url + "/" + response_body['id'], post_body) do |response, request, result|
          response_body = JSON.parse(response)
          expect(response_body['job']).to eq 'UPDATE'
        end
      end

      it 'patches a user record' do
        response = RestClient.post(url, post_body)
        response_body = JSON.parse(response)
        RestClient.patch(url + "/" + response_body['id'], post_body) do |response, request, result|
          response_body = JSON.parse(response)
          expect(response_body['job']).to eq 'UPDATE'
        end
      end

      it 'deletes a user record' do
        response = RestClient.post(url, post_body)
        response_body = JSON.parse(response)
        user_id = response_body['id']
        RestClient.delete(url + "/" + user_id)
        RestClient.get(url + "/" + user_id) do |response|
          expect(response.code).to eq 404
          expect(response.empty?)
        end
      end
    end

  end

end