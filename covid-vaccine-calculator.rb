require 'date'
require_relative 'lib/bloomberg_parser.rb'
require_relative 'lib/census_parser.rb'
require_relative 'lib/smart_prompt'

class CovidVaccineCalculator
  def initialize(state, age, percent_taking)
    @state = state
    @age = age
    @percent_taking = percent_taking
  end

  def calculate
    bloomberg_data = BloombergParser.new
    census_data = CensusParser.new(@state, @age)

    vaccinations_per_day_in_state_right_now = bloomberg_data.vaccinations_per_day_in_state(@state)

    already_completed_vaccination = bloomberg_data.completed_vaccinations_in_state(@state)

    people_ahead_of_you = census_data.people_older_than_you_in_your_state - already_completed_vaccination

    people_ahead_of_you_who_will_get_it = people_ahead_of_you * @percent_taking

    days_until_you_can_get_it = people_ahead_of_you_who_will_get_it / vaccinations_per_day_in_state_right_now

    day_you_can_get_it = Date.today + days_until_you_can_get_it

    "You can probably get the vaccine around #{day_you_can_get_it.strftime("%B %d, %Y")}"
  end
end

#state = SmartPrompt.get_input("Which state? Please use 2 letter code", "OH")
#age = SmartPrompt.get_input("How old?", 25).to_i
#percent_taking = SmartPrompt.get_input("What percentage of people do you think will get it when offered?", 70).to_f / 100

#puts CovidVaccineCalculator.new(state, age, percent_taking).calculate
