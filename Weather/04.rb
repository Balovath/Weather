require_relative "i"

module C
  include I

  def c1
    get_city
    puts "c1"
  end

  def c2
    puts "c2"
  end
end

require "net/http"
require "json"
require "uri"

class CityTranslator
  GOOGLE_TRANSLATE_API = "https://google-translate1.p.rapidapi.com/language/translate/v2".freeze

  def self.translate_city(city)
    return city unless contains_cyrillic?(city)

    translated_city = translate_to_english(city)
    translated_city
  end

  private

  def self.contains_cyrillic?(text)
    text =~ /[а-яА-Я]/
  end

  def self.translate_to_english(city)
    uri_encoded_city = encode_city_for_request(city)
    request = build_translation_request(uri_encoded_city)
    process_translation_response(request)
  end

  def self.encode_city_for_request(city)
    URI.encode_www_form_component(city)
  end

  def self.build_translation_request(uri_encoded_city)
    request = Net::HTTP::Post.new(GOOGLE_TRANSLATE_API)
    request["content-type"] = "application/x-www-form-urlencoded"
    request["Accept-Encoding"] = "application/gzip"
    request["X-RapidAPI-Key"] = "a9730c8a8amsh9a68b6ddd828f63p124c43jsn0f99bce20aa4"
    request["X-RapidAPI-Host"] = "google-translate1.p.rapidapi.com"
    request.body = "q=#{uri_encoded_city}&target=en&source=ru"
    request
  end

  def self.process_translation_response(request)
    puts request.read_body
    doc = JSON.parse(request.body)
    doc["data"]["translations"][0]["translatedText"]
  end
end
