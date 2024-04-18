# frozen_string_literal: true

require "byebug"
require "sinatra"

require_relative "interface"
require_relative "weather"

module WeatherApp
  class App < Sinatra::Base
    get "/" do
      erb :index
    end

    post "/info" do
      @city = Interface.set_city(params[:city])
      @date = Interface.set_date(params[:date])
      puts @city
      puts @date

      weather = Weather.new
      weather.get_info
      weather.hash_info

      @hours = weather.hash_info[:hours]
      @tmax = weather.hash_info[:tmax]
      @tmin = weather.hash_info[:tmin]

      erb :info
    end
  end
end
