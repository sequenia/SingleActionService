# SingleActionService

[![Gem Version](https://badge.fury.io/rb/single_action_service.svg)](https://rubygems.org/gems/single_action_service)

Implementation of a Service Object pattern in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'single_action_service'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install single_action_service

## Usage

1. Inherit:
```ruby
class MySingleAction < SingleActionService::Base
end
```
2. Create a constructor with parameters or pass them to call:
```ruby
# Usually a data source is passed
def initialize(x, y)
  @x = x
  @y = y
end
```
or
```ruby
def call(x, y)
end
```
3. Perform the action:
```ruby
sum = x + y
```
4. Return the result:
```ruby
success(sum)
```
or without data
```ruby
success
```
5. Or return an error:
```ruby
return error(sum, code: 1) unless sum.positive?
```
The first parameter is any data (optional).

The 'code' parameter is used to identify the error (optional).

6. You can process the result received from the service as follows:
```ruby
action = MySingleAction.new
result = action.call(1,2)
# or uses result.error?
if result.success?
  result.data
else
  {
    error_code: result.error_code,
    data: result.data
  }
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sequenia/single_action_service. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
