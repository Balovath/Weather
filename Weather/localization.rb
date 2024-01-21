require "net/http"
require "nokogiri"
require "json"
require "uri"
require_relative "city_translator"
require_relative "interface"
# require "translit"
require "byebug"

class Localization
  include Interface

  def self.get_coordinate
    api_key = ENV["OPEN_WHEATHER_MAP_KEY"]
    city = the_correct_name_of_the_city

    uri = URI.parse("http://api.openweathermap.org/geo/1.0/direct?q=#{city}&limit=5&appid=#{api_key}")

    response = Net::HTTP.get_response(uri)

    if response.code == "200"
      doc = JSON.parse(response.body).first.to_h
      save_request(doc)
      coordinate = read_request
    else
      puts "Error when executing a request to OpenWeatherMap"
      nil
    end
  end

  private

  def self.the_correct_name_of_the_city
    translate_city = CityTranslator.translate_city(Interface.get_city)
    city = translate_city
  end

  def self.save_request(doc)
    File.open("place.json", "w") do |file|
      file.write(JSON.dump(doc))
    end
  end

  def self.read_request
    file = File.read("place.json")
    doc = JSON.parse(file)
    { lat: "#{doc["lat"]}", lon: "#{doc["lon"]}" }
  end
end
