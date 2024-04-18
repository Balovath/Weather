require "bundler"
Bundler.require
require_relative "localization"
Dotenv.load(".env")

class Weather
  BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/".freeze
  include Interface

  attr_reader :hash_info

  def initialize
    @hash_info = {}
  end

  def get_info
    weather_api_key = ENV["WHEATHER_KEY"]
    coordinate = Localization.get_coordinate
    date = Interface.date

    url = "#{BASE_URL}#{coordinate[:lat]},#{coordinate[:lon]}/#{date}?key=#{weather_api_key}"
    uri = URI.parse(url)

    begin
      response = Net::HTTP.get_response(uri)
      if response.code == "200"
        doc = JSON.parse(response.body).to_h
        save_request(doc)
        show_forecast(read_request)
      else
        puts "Error when executing a request to Weather#{response.code}"
        read_request
      end
    rescue StandartError => e
      puts "There's been an unknown error: #{e.message}"
    rescue SocketError => e
      puts "Connection error with Weather API server"
    end
  end

  private

  def save_request(doc)
    begin
      File.open("wheather.json", "w") do |file|
        file.write(JSON.dump(doc))
      end
    rescue IOError => e
      puts "роизошла ошибка при сохранении файла: #{e.message}"
    rescue StandartError => e
      puts "Произошла неизвестная ошибка: #{e.message}"
    end
  end

  def celsius(kelvin_t)
    ((kelvin_t - 32) * 5 / 9).ceil(1)
  end

  def read_request
    begin
      file = File.read("wheather.json")
      response = JSON.parse(file)
    rescue IOError => e
      puts "роизошла ошибка при сохранении файла: #{e.message}"
    rescue StandartError => e
      puts "Произошла неизвестная ошибка: #{e.message}"
    end
  end

  def show_forecast(response)
    tmax = celsius(response["days"][0]["tempmax"])
    tmin = celsius(response["days"][0]["tempmin"])
    hours = response["days"][0]["hours"].each do |hour|
      hour["temp"] = celsius(hour["temp"])
    end

    @hash_info[:hours] = hours
    @hash_info[:tmax] = tmax
    @hash_info[:tmin] = tmin
  end
end
