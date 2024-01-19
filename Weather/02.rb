require "net/http"
require "json"

module I
  def get_city
    print "Введите название города:"
    STDIN.gets.strip
  end

  def get_date
    puts "Пример: 2023-10-11"
    print "Введите дату, которая вас интересует:"
    STDIN.gets.strip
  end
end

class Localization
  include I

  def get_coordinate
    ENV["API_KEY"] = "b0455dc4ba5462182675c3f5f394542b"
    api_key = ENV["API_KEY"]
    city = the_correct_name_of_the_city

    uri = URI.parse("http://api.openweathermap.org/geo/1.0/direct?q=#{city}&limit=5&appid=#{api_key}")

    response = Net::HTTP.get_response(uri)

    if response.code == "200"
      doc = JSON.parse(response.body).first.to_h
      save_request(doc)
      read_request
    else
      puts "Ошибка при выполнении запроса к OpenWeatherMap"
      nil
    end
  end

  private

  def the_correct_name_of_the_city
    translate_city = CityTranslator.translate_city(get_city)
    translate_city
  end

  def save_request(doc)
    File.open("place.json", "w") do |file|
      file.write(JSON.dump(doc))
    end
  end

  def read_request
    file = File.read("place.json")
    doc = JSON.parse(file)
    coordinate_hash = { lat: doc["lat"], lon: doc["lon"] }
  end
end

# Пример использования
localization = Localization.new
coordinates = localization.get_coordinate
puts "Координаты: #{coordinates}"
