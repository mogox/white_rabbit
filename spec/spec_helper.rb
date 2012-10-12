# debugging
require 'ruby-debug'
require 'looksee'

require 'active_support'
require 'active_support/core_ext/time/zones.rb'
require 'active_support/core_ext/date/calculations.rb'
require 'active_support/core_ext/date_time/calculations.rb'
require 'active_support/core_ext/numeric/time.rb'
require 'active_support/core_ext/object/instance_variables.rb'
require 'active_support/time_with_zone.rb'
require 'active_model'
require 'validates_timeliness'

require File.expand_path('../../lib/white_rabbit.rb', __FILE__)

## If your environment doesn't have a default Time.zone the test define one
Time.zone = "Pacific Time (US & Canada)" unless Time.zone
