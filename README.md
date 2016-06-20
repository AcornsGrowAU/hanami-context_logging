# Hanami::ContextLogging

This gem provides a Hanami logger formatter for logging with request auditing
context.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-context_logging'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hanami-context_logging

## Usage

Set up `Rack::RequestAuditing` so that the context is generated for each
request.  See [usage](https://github.com/Acornsgrow/rack-request_auditing) for
details on how to set up request auditing.  Afterwards, set the logger formatter
to an instance of `Hanami::ContextLogging::Formatter` to add the request
auditing context to logged messages.

```ruby
require 'hanami/context_logging/formatter'

module FooService
  class Application < Hanami::Application
    configure do
      logger Hanami::Logger.new(
        'FooService', formatter: Hanami::ContextLogging::Formatter.new)
    end
  end
end
```

The logger includes the `Rack::RequestAuditing` context in each message.

```ruby
FooService::Logger.error('Some error message')
```

```
app="FooService" severity="ERROR" time="2016-06-20T21:26:11.646+0000" correlation_id="f2c27802c8effb72" request_id="9004166f2ec204d4" parent_request_id="" Some error message
```

Note that this gem relies on the new formatter functionality introduced in the
[0.8.x](https://github.com/hanami/utils/tree/0.8.x) branch of `Hanami::Utils`.
As of the time of writing, this version has not been released.  Your project
will need to reference a [commit](https://github.com/hanami/utils/commit/8fcd94b6ebb13ff081b572b4a8abd3d62969828b) that contains this feature.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Acornsgrow/hanami-context_logging.
