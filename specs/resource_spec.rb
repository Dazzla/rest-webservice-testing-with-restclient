require_relative '../specs/spec_helper'

RSpec.describe('Resources') do
  let :resource_fields do
    %i[id name year color pantone_value]
  end

  describe 'list_resources' do
    let :url do
      BASE_URL + '/unknown'
    end

    it 'retrieves the resource list' do
      RestClient.get(url) do |response|
        response_body = JSON.parse(response)
        expect(response.code).to eq 200
        expect(response_body.key?('data'))
        expect(response_body['data'][0].length).to be > 1
        resource_fields.each do |field|
          expect(response_body['data'][0].key?(field))
        end
      end
    end
  end

  describe 'retrieve single resource' do
    let :url do
      BASE_URL + '/unknown/2'
    end

    it 'retrieves a single resource' do
      RestClient.get(url) do |response|
        response_body = JSON.parse(response)
        expect(response.code).to eq 200
        expect(response_body.key?('data'))
        resource_fields.each do |field|
          expect(response_body.key?(field))
        end
      end
    end
  end

  describe 'single resource not found' do
    let :url do
      BASE_URL + '/unknown/2888'
    end

    it 'returns an error for a non-existent resource' do
      RestClient.get(url) do |response|
        expect(response.code).to eq 404
        expect(response.empty?)
      end
    end
  end
end
