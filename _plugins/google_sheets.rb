require 'net/http'
api_key = 'AIzaSyCl1SKJlzGSHC2eG6qXUI9hjJagZ-eAVFU'
def fetch_sheet_data(api_key, spreadsheet_id, sheet_name)
  range = "#{sheet_name}"
  url = URI.parse("https://sheets.googleapis.com/v4/spreadsheets/#{spreadsheet_id}/values/#{range}?key=#{api_key}")
  
  response = JSON.parse(Net::HTTP.get(url).to_s)

  if response['values']
    response['values']
  else
    puts "Error fetching data: #{response['error']['message']}" if response['error']
    nil
  end
end

# Fetch data for 'contacts' sheet
contacts_data = fetch_sheet_data(api_key, '1hLlGLZuzDe8MqjlO8R2uCf7vYtQ_rJA6-fcy6TkY_WY', 'data')

# Fetch data for 'service' sheet
service_data = fetch_sheet_data(api_key, '1hLlGLZuzDe8MqjlO8R2uCf7vYtQ_rJA6-fcy6TkY_WY', 'service')

# Write data to JSON files
File.write('_data/contacts.json', JSON.dump(contacts_data))
File.write('_data/service.json', JSON.dump(service_data))
