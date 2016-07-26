require "spec_helper"

RSpec.describe FoodTruck do
  describe ".new" do
    it "takes name, day, meal, and location as arguments" do
      name = "Chicken & Rice Guys"
      day = "Friday"
      meal = "Lunch"
      location = "Financial District, Pearl Street at Franklin"
      expect { FoodTruck.new(name, day, meal, location) }.to_not raise_error
    end
  end

  let(:food_truck) {
    name = "Tenoch"
    day = "Tuesday"
    meal = "Lunch"
    location = "Stuart St. at Trinity Place"
    FoodTruck.new(name, day, meal, location)
  }

  describe "#readers" do
    it "should have readers for name, day, meal and location" do
      expect(food_truck.name).to eq("Tenoch")
      expect(food_truck.day).to eq("Tuesday")
      expect(food_truck.meal).to eq("Lunch")
      expect(food_truck.location).to include("Stuart St.")
    end
  end

  describe "to_s" do
    it "returns a string representation of the food truck" do
      expect(food_truck.to_s).to be_a(String)
      expect(food_truck.to_s).to eq("Tenoch for Lunch @ Stuart St. at Trinity Place")
    end
  end

  describe "class methods" do
    before(:each) do
      allow(FoodTruck).to receive(:doc) do
        html_fixture = File.join(File.dirname(__FILE__), "..", "support", "food_trucks.html")
        html = IO.read(html_fixture)
        Nokogiri::HTML(html)
      end
    end

    describe ".all" do
      it "returns an array of FoodTruck objects" do
        expect(FoodTruck.today).to be_an(Array)
        expect(FoodTruck.all).to_not be_empty
        expect(FoodTruck.all.first).to be_a(FoodTruck)
      end
    end

    describe ".today" do
      it "returns food trucks that are on the streets, today" do
        allow(FoodTruck).to receive(:day_of_week) { "Friday" }
        expect(FoodTruck.today).to_not be_empty
        expect(FoodTruck.today.length).to eq(1)
        expect(FoodTruck.today.first.name).to eq("Chicken & Rice Guys")
      end
    end
  end
end
