require_relative 'covid-vaccine-calculator.rb'

state = SmartPrompt.get_input("Which state? Please use 2 letter code", "OH")
age = SmartPrompt.get_input("How old?", 25).to_i
percent_taking = SmartPrompt.get_input("What percentage of people do you think will get it when offered?", 70).to_f / 100

puts CovidVaccineCalculator.new(state, age, percent_taking).calculate
