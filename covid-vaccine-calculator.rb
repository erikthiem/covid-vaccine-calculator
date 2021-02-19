require 'date'

people_in_ohio_25_and_older = 8055314

vaccinations_per_day_in_ohio_right_now = 56796

already_started = 1339231

people_ahead_of_you = people_in_ohio_25_and_older - already_started

percentage_of_people_who_will_get_it = 0.7

people_ahead_of_you_who_will_get_it = people_ahead_of_you * percentage_of_people_who_will_get_it

days_until_you_can_get_it = people_ahead_of_you_who_will_get_it / vaccinations_per_day_in_ohio_right_now

day_you_can_get_it = Date.today + days_until_you_can_get_it

puts "You can probably get the vaccine around #{day_you_can_get_it.strftime("%B %d, %Y")}"
