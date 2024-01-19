require "date"
require "byebug"

module Interface
  def self.get_city
    print "В ведите название города:"
    STDIN.gets.strip
  end

  def self.get_date
    date = ""
    until valide_date?(date)
      puts "Привемер: 2023-10-11"
      print "Введите дату которая вас интересует:"
      date = STDIN.gets.strip
      valide_date?(date)
    end
    date
  end

  private

  def self.valide_date?(date_str)
    format_date = "%Y-%m-%d"
    begin
      Date.strptime(date_str, format_date)
      return true
    rescue ArgumentError
      return false
    end
  end
end

# puts Interface.get_date

# def check_date
#   date = Date.parse(get_date)
#   Date.strptime("#{date}", "%Y-%m-%d")
# end
