require "white_rabbit/version"

module WhiteRabbit
  extend ActiveSupport::Concern

  Time::DATE_FORMATS[:us_date] = '%m/%d/%y'
  Time::DATE_FORMATS[:us_12_hour_time] = '%-l:%M%P'

  module ClassMethods
    SPLIT_FIELDS = [:date, :time]

    def split_datetime_fields_for(field_name, opts = {})
      # format symbol passed into .to_s for each split field, i.e. time.to_s(:format)
      default_opts = {:date_format => :us_date, :time_format => :us_12_hour_time}
      opts = default_opts.merge(opts)

      process_method_name = "process_#{field_name}"

      SPLIT_FIELDS.each do |type|
        # setter
        split_field_name = "#{field_name}_#{type}"
        define_method(split_field_name + '=') do |val|
         val.strip! if val.present?
         instance_variable_set "@#{split_field_name}", val
         send(process_method_name)
        end

        # getter
        define_method(split_field_name) do
          split_value = instance_values[split_field_name]
          if SPLIT_FIELDS.any? { |t| instance_values["#{field_name}_#{t}"].present? }
            split_value
          else
            send(field_name).try(:to_s, opts[:"#{type}_format"])
          end
        end
      end

      # process datetime field from split fields
      define_method(process_method_name) do
        date = instance_values["#{field_name}_date"]
        time = instance_values["#{field_name}_time"]
        parsed = nil
        if date && time
          parsed = Timeliness.parse("#{date} #{time}", :zone => Time.zone)
          send(:"#{field_name}=", parsed)
        end
      end
      send(:private, process_method_name)
    end
  end
end
