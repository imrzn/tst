require 'openssl'
require 'base64'
require 'net/http'

def decrypt_password(encrypted_password, key, iv)
  decipher = OpenSSL::Cipher.new('AES-256-CBC')
  decipher.decrypt
  decipher.key = key
  decipher.iv = iv

  decrypted = decipher.update(encrypted_password) + decipher.final
end

def read_from_file(filename)
  File.read(filename)
end

encrypted_password = read_from_file('_plugins/xyz/1.txt')
key = read_from_file('_plugins/xyz/2.txt')
iv = read_from_file('_plugins/xyz/3.txt')

decrypted_password = decrypt_password(encrypted_password, key, iv)

api_key = Base64.decode64(decrypted_password)
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
