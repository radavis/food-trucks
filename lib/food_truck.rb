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

  def to_s
    "#{name} for #{meal} @ #{location}"
  end

  def to_h
    { name: name, meal: meal, location: location }
  end

  class << self
    URL = "http://www.cityofboston.gov/foodtrucks/schedule-app-min.asp"

    def in(location, day = day_of_week)
      food_trucks.select { |truck| truck.location.include?(location) && truck.day == day }
    end

    def today
      food_trucks.select { |truck| truck.day == day_of_week }
    end

    def all
      food_trucks
    end

    private

    def food_trucks
      @@food_trucks ||= load_from_document
    end

    def load_from_document
      result = []
      doc.css('tr.trFoodTrucks').each do |row|
        name = row.css('td.com').text
        day = row.css('td.dow').text
        meal = row.css('td.tod').text
        row.css('td.loc script').remove
        location = row.css('td.loc').text

        result << FoodTruck.new(name, day, meal, location)
      end

      result
    end

    def doc
      Nokogiri::HTML(open(URL).read)
    end

    def day_of_week
      Date::DAYNAMES[Date.today.wday]
    end
  end
end
