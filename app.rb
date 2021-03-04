require 'sinatra'
require_relative 'covid-vaccine-calculator'
require_relative 'lib/state_lookup.rb'

get '/' do
  @states = StateLookup.all_states_with_abbreviations
  erb :index
end

post '/' do
  state = params["state"]
  age = params["age"].to_i
  percent_taking = params["percent_taking"].to_f / 100
  break_bloomberg_cache = false

  CovidVaccineCalculator.new(state, age, percent_taking, break_bloomberg_cache).calculate
end
