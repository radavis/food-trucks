#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

class FoodTruck
  URL = "http://www.cityofboston.gov/foodtrucks/schedule-app-min.asp"
  @@food_trucks = []

  def self.at(location, day=Date::DAYNAMES[Date.today.wday])
    @@food_trucks.select { |truck| truck.location.include?(location) && truck.day == day}
  end

  def self.all
    @@food_trucks
  end

  def self.load
    doc = Nokogiri::HTML(open(URL).read)

    doc.css('.trFoodTrucks').each do |row|
      name = row.css('.com').text
      day = row.css('.dow').text
      meal = row.css('.tod').text
      row.css('.loc script').remove
      location = row.css('.loc').text

      FoodTruck.new(name, day, meal, location)
    end
  end

  attr_reader :name, :day, :meal, :location

  def initialize(name, day, meal, location)
    @name = name
    @day = day
    @meal = meal
    @location = location
    @@food_trucks << self
  end
end

def main
  FoodTruck.load

  if !ARGV.empty?
    locations = ARGV
  else
    locations = %w(Chinatown Congress Dewey Seaport)
  end

  locations.each do |location|
    trucks = FoodTruck.at(location)
    trucks.sort_by! { |truck| [truck.meal, truck.location, truck.name] }
    trucks.each do |truck|
      puts "#{truck.name} @ #{truck.location} for #{truck.meal} on #{truck.day}"
    end
  end
end

main
