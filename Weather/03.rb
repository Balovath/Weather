require_relative "05"
require "dotenv"
Dotenv.load(".env")

module A
  include B

  def a1
    puts "a1"
  end

  def a2
    puts "a2"
  end
end

class Sample
  include A

  def s1
    puts "s1"
  end
end

# samp = Sample.new
# samp.a1
# samp.a2
# samp.b1
# samp.b2
# samp.s1

a = ENV["A"]
puts a

# app.rb
