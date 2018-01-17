require 'rest-client'
require 'rspec/expectations'
require 'json'


url = "https://reqres.in/api/users"

response = JSON.parse(RestClient.get(url))
expect(response).to have_key


