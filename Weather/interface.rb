require "date"
require "byebug"

module Interface
  def self.get_city
    print "Enter the name of the city:"
    STDIN.gets.strip
  end

  def self.get_date
    date = ""
    until valide_date?(date)
      puts "Example: 2023-10-11"
      print "Enter the date you are interested in:"
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
