RDStation.configure do |config|
  config.client_id = ENV['CLIENT_ID']
  config.client_secret = ENV['CLIENT_SECRET']
  # config.refresh_token = ENV['REFRESH_TOKEN']
  # config.refresh_token = '0Q-eVVtGOza2AMZfHb06QZSn5Sjfrqm4oXF_0LQ0muM'
  # config.redirect_uri = 'http://localhost:3000/workshop'
  config.on_access_token_refresh do |authorization|
    # Update the stored access_token using ActiveRecord or any other appropriate method
    MyStoredAuth.where(refresh_token: authorization.refresh_token).update_all(access_token: authorization.access_token)
  end
end

rdstation_authentication = RDStation::Authentication.new
# Substitua com o código retornado da RD Station
access_token_data = ENV['ACCESS_TOKEN']

# Extrair o token de acesso do resultado
access_token = ENV['ACCESS_TOKEN']
