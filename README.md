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

Create an inheritor from a `SingleActionService::Base` with a single method named `call`

```ruby
class Summator < SingleActionService::Base
  def call
  end
end
```

Create a constructor with parameters

```ruby
class Summator < SingleActionService::Base
  def initialize(x, y)
    @x = x
    @y = y
  end
end
```

or pass them to the call method

```ruby
class Summator < SingleActionService::Base
  def call(x, y)
  end
end
```

Perform the action and return the result by calling `success(data = nil)`

```ruby
class Summator < SingleActionService::Base
  def call(x, y)
    sum = x + y
    success(sum)
  end
end
```

or return the error based on the validations by calling `error(data: nil, code: nil)`

```ruby
class Summator < SingleActionService::Base
  NIL_NUMBERS_ERROR = :nil_numbers_error

  def call(x, y)
    if x.nil? || y.nil?
      return error(code: NIL_NUMBERS_ERROR)
    end
  end
end
```

Call the service and process a result

```ruby
summator = Summator.new
result = summator.call(1, 2)

if result.success?
  result.data
else
  result.error_code
end
```

Or you can use a `data!` method if you want to throw an exception when an error has occurred:

```ruby
begin
  result = Summator.new.call(1, 2).data!
rescue SingleActionService::InvalidResult => e
  e.result.error_code
end
```

You can define a list of errors of a service by calling a `self.errors(errors_data)` method.<br/>For each error, a method `#{error_name}_error(data = nil)` will be generated to instantiate the result with the appropriate code and optional data:

```ruby
class Summator < SingleActionService::Base
  errors [
    { name: :nil_numbers, code: 1 }
  ]

  def call(x, y)
    if x.nil? || y.nil?
      return nil_numbers_error
    end
  end
end
```

You can check for the specific error calling an autogenerated checking method of the result:

```ruby
result = Summator.new.call(nil, nil)
result.nil_numbers_error? # true
```

## API Reference

### SingleActionService::Base

A base class for services. Create an inheritor from him to use it. Methods:

Name                             |Description
---------------------------------|-----------
`success(data = nil)`            |Returns a successful `SingleActionService::Result` with<br/>data passed in arguments.
`error(data: nil, code: nil)`    |Returns an error `SingleActionService::Result` with<br/> data and the error code passed in arguments.
`#{error_name}_error(data = nil)`|Autogenerated method to create an error result <br/>with the specific error code<br/>without having to pass it in arguments.<br/>Generated for each error passed to the `self.errors` method.<br/>Returns an error `SingleActionService::Result` with<br/> data passed to arguments.
`self.errors(errors_data)`       |Call this method to identify possible service errors.<br/>Accepts an array of objects:<br/>`{ name: :error_name, code: :error_code }`

### SingleActionService::Result

A base class for the result that the service returns. Instantiated by service methods such as `success`, `error` and autogenerated error methods. Methods:

Name                  |Description
----------------------|-----------
`success?`            |Call this method to check the result for success.<br/>Returns `true` for successful results created by the<br/>`success` method of a service.
`error?`              |Call this method to check the result for error.<br/>Returns `false` for error results created by the<br/>`error` method of a service or by autogenerated<br/> error methods.
`#{error_name}_error?`|Call this method to check the result for the specific error.<br/>Autogenerated for each error passed to the `self.errors`<br/> of a service.
`data`                |Returns data passed to the result instantiation method
`data!`               |Returns data passed to the result instantiation method.<br/>Throws a `SingleActionService::InvalidResult`<br/>exception if the result contains an error.

### SingleActionService::InvalidResult

An exception thrown by the `data!` method of a result. Methods:

Name        |Description
------------|-----------
`result`    |Returns a `SingleActionService::Result`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sequenia/single_action_service. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
