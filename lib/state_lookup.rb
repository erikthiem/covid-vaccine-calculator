class StateLookup
  FIPS_STATE_CODES_DATA_FILE = "data/state_codes.txt"

  def self.all_states_with_abbreviations
    result = []
    CSV.foreach(FIPS_STATE_CODES_DATA_FILE, :headers => true, :col_sep => "|") do |row|
      abbreviation = row.to_h["STUSAB"]
      name = row.to_h["STATE_NAME"]
      result.push( { abbreviation: abbreviation, name: name })
    end
    return result
  end

  def self.fips_code_for_state(state)
    CSV.foreach(FIPS_STATE_CODES_DATA_FILE, :headers => true, :col_sep => "|") do |row|
      if row.to_h["STUSAB"] == state
        return row.to_h["STATE"].to_i.to_s
      end
    end
  end
end
