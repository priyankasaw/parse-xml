require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/hash'
require 'json'
require 'sqlite3'
require './db_connection'
require './shipping_data_output'

def fetch_xml
  begin
    xml_input = Nokogiri::XML(open(
                            "https://raw.githubusercontent.com/hautelook/shipment-tracking/master/tests/fixtures/ups.xml"
                            ))
  rescue => error
    puts "Error fetching XML data : #{error}"
  end
end

xml_input = fetch_xml

def save_xml_data(xml_input)
	# Fetch shipment response
	$response = xml_input.css("Response")
	response_code = $response.css("ResponseStatusCode").inner_text
	response_desc = $response.css("ResponseStatusDescription").inner_text
	puts "Response: " + response_desc
 	
 	$shipment = xml_input.css("Shipment")

 	# Get shipment number & shipment identification number
	shipper_no = $shipment.css("ShipperNumber").inner_text

	# Get shipment identification number
	shipment_identification_no = $shipment.css("ShipmentIdentificationNumber").inner_text

	# Convert shipment data to jsn format
	$shipment = xml_input.css("Shipment")
	shipping_json_data = Hash.from_xml($shipment.to_s).to_json

	# Insert parse data into database.
	insert_details(response_code, shipper_no, shipment_identification_no, shipping_json_data)

	# Output shipping json response
	get_shipping_data(shipper_no)
end

def insert_details(response_code, shipper_no, shipment_identification_no, shipping_json_data)
  db = connect_db()
  #db.execute "DELETE FROM shipping_details"
  save_obj = db.execute "INSERT INTO shipping_details (shipper_no, status, shipment_identification_no, shipping_json_response) VALUES (?, ?, ?, ?)", shipper_no, response_code, shipment_identification_no, shipping_json_data
  if save_obj
    puts 'Shipping details saved successfully'
  else
    puts 'Error while saving record!'
  end
end

# Parse xml data and insert into db and display the result
save_xml_data(xml_input)