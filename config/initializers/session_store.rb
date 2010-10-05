# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pobazaar_session',
  :secret      => 'f7d3cc5bd6d9e732c500893f5336609f652806bef32cd3f5021fac4e59325238f7986c2b4ed78ee0551b54106d74289618f73418bcb7b2a19e53a92feb94b742'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
