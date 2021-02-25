require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
require 'yaml'

class BloombergParser

  BLOOMBERG_DATA_URL = "https://www.bloomberg.com/graphics/covid-vaccine-tracker-global-distribution/" 
  BLOOMBERG_DATA_CACHED_FILE = "data/bloomberg_data.yml"

  def initialize
    if recent_cached_data?
      ruby_hash_of_all_data = retrieve_cached_data()
    else
      full_html_data = download_data()
      full_nokogiri_data = Nokogiri::HTML(full_html_data)
      data_js = full_nokogiri_data.css('script#dvz-data-cave')[0]
      ruby_hash_of_all_data = JSON.parse(data_js)
      cache_data(ruby_hash_of_all_data)
    end

    @usa_vaccination_data = ruby_hash_of_all_data["vaccination"]["usa"]
  end

  def vaccinations_per_day_in_state(requested_state_name)
    all_data_for_state(requested_state_name)["noDosesTotalLatestRateValue"]
  end

  def completed_vaccinations_in_state(requested_state_name)
    all_data_for_state(requested_state_name)["noCompletedVaccination"]
  end

  private

  def all_data_for_state(state_name)
    @usa_vaccination_data.select {|state| state["name"] == state_name}.first
  end

  def cache_data(data)
    File.open(BLOOMBERG_DATA_CACHED_FILE, "w") { |file| file.write(data.to_yaml) }
  end

  def recent_cached_data?
    return false unless File.exist?(BLOOMBERG_DATA_CACHED_FILE)
    modified_time = File.mtime(BLOOMBERG_DATA_CACHED_FILE)
    return modified_time >= Time.now - (3600 * 24)
  end

  def retrieve_cached_data
    YAML.load(File.read(BLOOMBERG_DATA_CACHED_FILE))
  end

  def download_data
    uri = URI.parse(BLOOMBERG_DATA_URL)
    request = Net::HTTP::Get.new(uri)
    request["User-Agent"] = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:85.0) Gecko/20100101 Firefox/85.0"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    request["Accept-Language"] = "en-US,en;q=0.5"
    request["Connection"] = "keep-alive"
    request["Upgrade-Insecure-Requests"] = "1"
    request["Cache-Control"] = "max-age=0"
    request["Te"] = "Trailers"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    return response.body
  end
end
