
require 'spaceship'

# Set your Apple ID and app-specific password here
apple_id = "ahmed.abuelregal@expertapps.com.sa"
password = "gdfm-pgpi-lphq-wlgz"

# Initiate a new session and prompt for 2FA
Spaceship::ConnectAPI.login(apple_id, password)
puts "Session generated successfully!"

# Print session details
session = Spaceship::ConnectAPI::Session.current
puts "Session token: #{session.to_json}"