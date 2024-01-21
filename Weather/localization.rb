# frozen_string_literal: true

require "byebug"
require "json"
require "net/http"
require "nokogiri"
require "uri"
require_relative "city_translator"
require_relative "interface"

class Localization
  BASE_URL = "http://api.openweathermap.org/geo/1.0/"
  include Interface

  def self.get_coordinate
    api_key = ENV["OPEN_WHEATHER_MAP_KEY"]
    city = the_correct_name_of_the_city

    url = "#{BASE_URL}direct?q=#{city}&limit=5&appid=#{api_key}"
    uri = URI.parse(url)

    response = Net::HTTP.get_response(uri)

    if response.code == "200"
      doc = JSON.parse(response.body).first.to_h
      save_request(doc)
      read_request
    else
      puts "Error when executing a request to OpenWeatherMap"
      nil
    end
  end

  def self.the_correct_name_of_the_city
    CityTranslator.translate_city(Interface.city)
  end

  def self.save_request(doc)
    File.open("place.json", "w") do |file|
      file.write(JSON.dump(doc))
    end
  end

  def self.read_request
    file = File.read("place.json")
    doc = JSON.parse(file)
    { lat: (doc["lat"]).to_s, lon: (doc["lon"]).to_s }
  end
end
