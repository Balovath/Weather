require "net/http"
require "json"
require "uri"
require "byebug"

class CityTranslator
  GOOGLE_TRANSLATE_API = "https://google-translate1.p.rapidapi.com/language/translate/v2".freeze

  def self.translate_city(city)
    return city unless contains_cyrillic?(city)

    translated_city = translate_to_english(city)
  rescue StandardError => e
    puts "Произошла ошибка: #{e.message}"
    city
  end

  private

  def self.contains_cyrillic?(text)
    text =~ /[а-яА-Я]/
  end

  def self.translate_to_english(city)
    url = URI(GOOGLE_TRANSLATE_API)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    translated_city = URI.encode_www_form_component(city)
    request = build_translation_request(translated_city)
    response = http.request(request)

    process_translation_response(response)
  end

  def self.build_translation_request(translated_city)
    ENV["API_KEY"] = "b0455dc4ba5462182675c3f5f394542b"
    api_key = ENV["API_KEY"]

    request = Net::HTTP::Post.new(GOOGLE_TRANSLATE_API)
    request["content-type"] = "application/x-www-form-urlencoded"
    request["Accept-Encoding"] = "application/gzip"
    request["X-RapidAPI-Key"] = api_key
    request["X-RapidAPI-Host"] = "google-translate1.p.rapidapi.com"
    request.body = "q=#{translated_city}&target=en&source=ru"
    request
  end

  def self.process_translation_response(response)
    doc = JSON.parse(response.body)
    doc["data"]["translations"][0]["translatedText"]
  end
end
