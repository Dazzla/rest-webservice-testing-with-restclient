##BJSS Demo spec tests

Run with:

```bash
bundle exec rspec ./specs/ .
```


###TODO List



```ruby
      it 'successfully creates a user' do
        RestClient.post(url, post_body) do |response|
          expect(response.code).to eq 201
          response_body = JSON.parse(response.body)
          expect(response_body['name']).to match /test_user_\d+/
          #TODO: add createdAt check
        end
      end
#specs/users_spec.rb:91
```


```ruby
RSpec.describe('Users') do
  #...
end

  #TODO: This spec could be better. Needs to be tidied to reduce repetition and improve readability
  #TODO: Mock service
 #specs/users_spec.rb:5 
```