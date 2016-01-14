require 'nokogiri'
require 'open-uri'

class FoodTruck
  attr_reader :name, :day, :meal, :location

  def initialize(name, day, meal, location)
    @name = name
    @day = day
    @meal = meal
    @location = location
  end

  def neighborhood
    result = nil
    if location.include?(" - ")
      result, _ = location.split(" - ")
    end
    result
  end

  def to_s
    result = "#{name} for #{meal}"
    if neighborhood
      result += " in #{neighborhood}"
    else
      result += " @ #{location}"
    end
    result
  end

  class << self
    URL = "http://www.cityofboston.gov/foodtrucks/schedule-app-min.asp"
    @@food_trucks = []

    def in(location, day = day_of_week)
      @@food_trucks.select { |truck| truck.location.include?(location) && truck.day == day }
    end

    def today
      @@food_trucks.select { |truck| truck.day == day_of_week }
    end

    def all
      @@food_trucks
    end

    def load
      doc.css('.trFoodTrucks').each do |row|
        name = row.css('.com').text
        day = row.css('.dow').text
        meal = row.css('.tod').text
        row.css('.loc script').remove
        location = row.css('.loc').text

        @@food_trucks << FoodTruck.new(name, day, meal, location)
      end
    end

    private
    def doc
      Nokogiri::HTML(open(URL).read)
    end

    def day_of_week
      Date::DAYNAMES[Date.today.wday]
    end
  end
end
