require 'sinatra'
require_relative 'covid-vaccine-calculator'

get '/' do
  erb :index
end

post '/' do
  state = params["state"]
  age = params["age"].to_i
  percent_taking = params["percent_taking"].to_f / 100
  break_bloomberg_cache = false

  CovidVaccineCalculator.new(state, age, percent_taking, break_bloomberg_cache).calculate
end
