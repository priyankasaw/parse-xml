def get_shipping_data(shipper_no)
  db = connect_db()
  results = db.query "SELECT shipping_json_response FROM shipping_details WHERE shipper_no = ?",shipper_no
  result = results.next
  parse_json(result['shipping_json_response'])
end

def parse_json(xml_json)
	obj = JSON.parse(xml_json)
	puts " "
	puts 'Shipping Address: '
	puts obj["Shipment"]["Shipper"]["Address"]["AddressLine1"]+', '+
			obj["Shipment"]["Shipper"]["Address"]["City"]+', '+
			obj["Shipment"]["Shipper"]["Address"]["StateProvinceCode"]+', '+
			obj["Shipment"]["Shipper"]["Address"]["PostalCode"]+', '+
			obj["Shipment"]["Shipper"]["Address"]["CountryCode"]
	puts " "
	puts 'Ship To: '
	puts obj["Shipment"]["ShipTo"]["Address"]["City"]+', '+
			obj["Shipment"]["ShipTo"]["Address"]["StateProvinceCode"]+', '+
			obj["Shipment"]["ShipTo"]["Address"]["PostalCode"]+', '+
			obj["Shipment"]["ShipTo"]["Address"]["CountryCode"]
	puts " "
	puts 'Reference Number: '
	obj["Shipment"]["ReferenceNumber"].each do |d|
		puts "Code: " + d['Code'] + ' Value: ' + d['Value']
	end
end
