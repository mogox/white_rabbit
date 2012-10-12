require 'spec_helper'

# For testing, we define a "long date" format
Time::DATE_FORMATS[:long_date] = "%B %d, %Y"
# Letting ValidatesTimeliness parse date long format
ValidatesTimeliness.parser.add_formats(:date, 'mmm d, yyyy')
# Letting ValidatesTimeliness parse datetime long format
ValidatesTimeliness.parser.add_formats(:datetime, 'mmm d, yyyy h:nnampm')

describe WhiteRabbit do
  class TestClass
    include WhiteRabbit

    attr_accessor :start

    split_datetime_fields_for :start

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
  end

  shared_examples_for "time parsing" do
    context "start_date" do
      describe "#start_date=" do
        it "should not set start without a start_time" do
          test_class = TestClass.new(:start_date => @start_date)
          test_class.start.should be_nil
        end

        it "should not set start with an invalid start_date" do
          test_class = TestClass.new(:start_date => '123/123/123')
          test_class.start.should be_nil
        end

        it "should not overwrite start without a start_time" do
          test_class = TestClass.new(:start => @datetime + 1.day)
          test_class.start_date = @start_date
          test_class.start.should eq(@datetime + 1.day)
        end

        it "should set start with a previously set start_time" do
          test_class = TestClass.new(:start_time => @start_time)
          test_class.start_date = @start_date
          test_class.start.should eq(@datetime)
        end
      end

      describe "#start_date" do
        it "should return start_date, even if start has not been set" do
          test_class = TestClass.new(:start_date => @start_date)
          test_class.start_date.should eq(@start_date)
        end

        it "should return start in %m/%d/%Y format" do
          test_class = TestClass.new(:start => @datetime)
          test_class.start_date.should eq(@start_date)
        end

        it "should return nil if start and start_time has been set" do
          test_class = TestClass.new(:start => @datetime)
          test_class.start_time = '123'
          test_class.start_date.should be_nil
        end
      end
    end

    context "start_time" do
      describe "#start_time=" do
        it "should not set start without a start_time" do
          test_class = TestClass.new(:start_time => @start_time)
          test_class.start.should be_nil
        end

        it "should not overwrite start without a start_time" do
          test_class = TestClass.new(:start => @datetime + 1.day)
          test_class.start_time = @start_time
          test_class.start.should eq(@datetime + 1.day)
        end

        it "should set start with a previously set start_date" do
          test_class = TestClass.new(:start_date => @start_date)
          test_class.start_time = @start_time
          test_class.start.should eq(@datetime)
        end

        it "should not set start with an invalid start_time" do
          test_class = TestClass.new(:start_time => '123:345')
          test_class.start.should be_nil
        end
      end

      describe "#start_time" do
        it "should return start_time, even if start has not been set" do
          test_class = TestClass.new(:start_time => @start_time)
          test_class.start_time.should eq(@start_time)
        end

        it "should return start in %I:%m%p format" do
          test_class = TestClass.new(:start => @datetime)
          test_class.start_time.should eq(@start_time)
        end
      end
    end

    it "should accept date and time in two fields in us date format" do
      test_class = TestClass.new(:start_date => @start_date, :start_time => @start_time)
      test_class.start.should eq(@datetime)
    end

    it "should accept date and time in two fields in long date format" do
      test_class = TestClass.new(:start_date => @start_date_long, :start_time => @start_time)
      test_class.start.should eq(@datetime)
    end
  end

  describe "in system time" do
    before do
      @datetime = Time.zone.local(2011, 8, 12, 13, 30, 0)
      @start_date = @datetime.to_s(:us_date)
      @start_date_long = @datetime.to_s(:long_date)
      @start_time = @datetime.to_s(:us_12_hour_time)
    end

    it_should_behave_like 'time parsing'
  end

  describe "in TOT time" do
    before(:all) do
      @original_timezone = Time.zone
      Time.zone = "Nuku'alofa"
    end

    context "Correct ordering" do
      before do
        Time.zone = "Pacific Time (US & Canada)" unless Time.zone
        @datetime = Time.zone.local(2011, 8, 12, 13, 30, 0)
        @start_date = @datetime.to_s(:us_date)
        @start_date_long = @datetime.to_s(:long_date)
        @start_time = @datetime.to_s(:us_12_hour_time)
      end

      it_should_behave_like 'time parsing'
    end

    after(:all) do
      Time.zone = @original_timezone
    end
  end
end
