require 'csv'
require 'pry'

class CensusParser

  CENSUS_DATA_FILE = "data/sc-est2019-agesex-civ.csv"
  FIPS_STATE_CODES_DATA_FILE = "data/state_codes.txt"

  def initialize(state, age)
    @state = state
    @age = age

  end

  def people_older_than_you_in_your_state
    running_count = 0

    CSV.foreach(CENSUS_DATA_FILE, :headers => true) do |row|
      # Only care about selected state
      if row.to_h["STATE"] == fips_code_for_state(@state)

        # Only care about all sexes, not male- or female-specific data
        if row.to_h["SEX"] == "0"

          # Only care about age greater than or equal to requested age
          # An age of "999" is used by this dataset to indicate total population
          if row.to_h["AGE"].to_i >= @age && row.to_h["AGE"] != "999"

            # Only care about 2019 data since it's the most recent in this dataset
            running_count += row.to_h["POPEST2019_CIV"].to_i
          end
        end
      end
    end

    return running_count
  end

  private

  def fips_code_for_state(state)
    CSV.foreach(FIPS_STATE_CODES_DATA_FILE, :headers => true, :col_sep => "|") do |row|
      if row.to_h["STUSAB"] == state
        return row.to_h["STATE"]
      end
    end
  end
end
