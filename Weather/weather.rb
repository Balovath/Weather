require "net/http"
require "uri"
require "byebug"
require "json"
require "dotenv"
require_relative "localization"
Dotenv.load(".env")

class Weather
  include Interface

  def get_info
    my_api = ENV["WHEATHER_KEY"]
    coordinate = Localization.get_coordinate
    date = Interface.get_date

    uri = URI.parse("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{coordinate[:lat]},#{coordinate[:lon]}/#{date}?key=#{my_api}")

    response = Net::HTTP.get_response(uri)
    if response.code == "200"
      doc = JSON.parse(response.body).to_h
      save_request(doc)
      show_forecast(read_request)
    else
      puts "Error when executing a request to Weather"
      nil
    end
  end

  private

  def save_request(doc)
    File.open("wheather.json", "w") do |file|
      file.write(JSON.dump(doc))
    end
  end

  def celsius(kelvin_t)
    ((kelvin_t - 32) * 5 / 9).ceil(1)
  end

  def read_request
    file = File.read("wheather.json")
    response = JSON.parse(file)
  end

  def show_forecast(response)
    tmax = response["days"][0]["tempmax"]
    tmin = response["days"][0]["tempmin"]

    puts "Date #{response["days"][0]["datetime"]}"
    puts "Visibility #{response["days"][0]["visibility"]}"
    puts "Max temp: #{celsius(tmax)}"
    puts "Min temp: #{celsius(tmin)}"
  end
end

weather = Weather.new
weather.get_info
