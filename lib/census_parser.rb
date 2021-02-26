require 'csv'
require 'pry'

class CensusParser

  CENSUS_DATA_FILE = "data/sc-est2019-agesex-civ.csv"
  OPTIMIZED_STATE_AGE_DATA = "data/optimized-state-age-data.yml"
  FIPS_STATE_CODES_DATA_FILE = "data/state_codes.txt"

  def initialize(state, age)
    @state = state
    @age = age
  end

  def people_older_than_you_in_your_state
    optimized_state_age_data["#{fips_code_for_state(@state)}:#{@age}"]
  end

  private

  def fips_code_for_state(state)
    CSV.foreach(FIPS_STATE_CODES_DATA_FILE, :headers => true, :col_sep => "|") do |row|
      if row.to_h["STUSAB"] == state
        return row.to_h["STATE"].to_i.to_s
      end
    end
  end

  def optimized_state_age_data
    if File.exist?(OPTIMIZED_STATE_AGE_DATA)
      return YAML.load(File.read(OPTIMIZED_STATE_AGE_DATA))
    else
      optimized_data = optimized_census_data_for_age_lookups
      File.open(OPTIMIZED_STATE_AGE_DATA, "w") { |file| file.write(optimized_data.to_yaml) }
      return optimized_data
    end
  end

  # Sums up ages per state to generate a data structure that is much faster to parse
  # Structure will look like {"STATE:AGE" => people_AGE_and_older_in_STATE}
  def optimized_census_data_for_age_lookups

    optimized_data_structure = {}

    CSV.foreach(CENSUS_DATA_FILE, :headers => true) do |row|

      state_fips_code = row.to_h["STATE"]
      
      if state_fips_code != "0" # Ignore national results

        # Only care about all sexes, not male- or female-specific data
        if row.to_h["SEX"] == "0"

          # Ages for all states in this data source are 0 to 85
          age = row.to_h["AGE"].to_i
          if age >= 0 && age <= 85

            pop_of_age = row.to_h["POPEST2019_CIV"].to_i

            for backfilled_age in 0..age-1
              # increase count for all previous ages
              previous_count = optimized_data_structure["#{state_fips_code}:#{backfilled_age}"]
              optimized_data_structure.merge!( {"#{state_fips_code}:#{backfilled_age}" => pop_of_age + previous_count.to_i } )
            end

            optimized_data_structure.merge!( {"#{state_fips_code}:#{age}" => pop_of_age } )
          end
        end
      end
    end

    optimized_data_structure
  end
end
