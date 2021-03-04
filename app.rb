require 'sinatra'
require_relative 'covid-vaccine-calculator'

get '/' do
  erb :index
end

post '/' do
  state = params["state"]
  age = params["age"].to_i
  percent_taking = params["percent_taking"].to_f / 100

  CovidVaccineCalculator.new(state, age, percent_taking, false).calculate
end
