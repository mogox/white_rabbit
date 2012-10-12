# White Rabbit

## Description

Ruby library for This library let's you set a date and a time of a datetime attribute in from a rails model to allow you have separate UI elements for date and time.

## Installation

Add this line to your application's Gemfile:

    gem 'white_rabbit'

and then

    bundle install

Or install it yourself as:

    $ gem install white_rabbit

## Usage

The spec contains this example:

    class TestClass
      include WhiteRabbit

      # notice only the start accessor is defined
      attr_accessor :start

      split_datetime_fields_for :start

      def initialize(attributes = {})
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end
    end

Then you can do:

    test_class = TestClass.new
    test_class.start_date = 1.day.ago
    test_class.start_time = 1.hour.ago

When both, date and time, are set and can be parsed via Timeliness you get a valid object:

    test_class.start.class # will print "ActiveSupport::TimeWithZone"

However, the date and time parameters will be a string, since it's easier to use in your views.

    test_class.start_date.class # will print "String" in the default us_format
    test_class.start_time.class # will print "String"

To add more date/time formats, first define your date or time format:

    Time::DATE_FORMATS[:long_date] = "%B %d, %Y"

Then define the parse format for Validates_Timeliness:

    ValidatesTimeliness.parser.add_formats(:datetime, 'mmm d, yyyy h:nnampm')

More about ValidatesTimeliness: http://github.com/adzap/validates_timeliness

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Running the Specs

    rspec spec/

## Authors
  People who have contributed to the initial version:
  @kasima, @wonnage, @chriswfx, @mogox