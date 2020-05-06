def connect_db()
  db = SQLite3::Database.open 'shipping.db'
  db.results_as_hash = true
  db.execute "CREATE TABLE IF NOT EXISTS shipping_details(shipper_no INT, status TINYINT, shipment_identification_no INT, shipping_json_response TEXT)"
  return db
end
