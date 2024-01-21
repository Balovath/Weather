# frozen_string_literal: true

require "date"
require "byebug"

module Interface
  class << self
    attr_accessor :city, :date

    def set_city(city)
      @city = city
    end

    def set_date(value)
      @date = valid_date_format?(value) ? value : nil
    end

    private

    def valid_date_format?(date_str)
      format_date = "%Y-%m-%d"
      begin
        Date.strptime(date_str, format_date)
        true
      rescue ArgumentError
        false
      end
    end
  end
end
