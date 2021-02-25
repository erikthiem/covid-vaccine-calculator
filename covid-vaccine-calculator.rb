require 'date'
require_relative 'lib/bloomberg_parser.rb'
require_relative 'lib/census_parser.rb'
require_relative 'lib/smart_prompt'

state = SmartPrompt.get_input("Which state? please use 2 letter code", "OH")
bloomberg_data = BloombergParser.new
census_data = CensusParser.new(state, 25)

vaccinations_per_day_in_state_right_now = bloomberg_data.vaccinations_per_day_in_state(state)

already_completed_vaccination = bloomberg_data.completed_vaccinations_in_state(state)

people_ahead_of_you = census_data.people_older_than_you_in_your_state - already_completed_vaccination

percentage_of_people_who_will_get_it = 0.7

people_ahead_of_you_who_will_get_it = people_ahead_of_you * percentage_of_people_who_will_get_it

days_until_you_can_get_it = people_ahead_of_you_who_will_get_it / vaccinations_per_day_in_state_right_now

day_you_can_get_it = Date.today + days_until_you_can_get_it


puts "You can probably get the vaccine around #{day_you_can_get_it.strftime("%B %d, %Y")}"
