class LeadsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create]

  def new
    @lead = Lead.new
    @hide_navbar = true
  end

  # def initialize
  #   @access_token = ''
  # end

  def create
    @lead = Lead.new(lead_params)
    @lead.tags = ['Videoaula_JohnBThompson_Jun23']

    url = URI('https://api.rd.services/platform/contacts')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{refresh_token}"
    request.body = { name: @lead.name, email: @lead.email, tags: ['videoaula_johnbthompson_jun23'] }.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      puts result
      flash[:notice] = 'Aproveite a masterclass!'
      redirect_to root_path
    else
      if @lead.save
        # redirect_to root_path, notice: 'Aproveite o workshop!'
        p 'Lead salvo so na DB local'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def refresh_token
    url = URI("https://api.rd.services/auth/token")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request.body = "{\"client_id\":\"#{ENV['CLIENT_ID']}\",\"client_secret\":\"#{ENV['CLIENT_SECRET']}\",\"refresh_token\":\"#{ENV['REFRESH_TOKEN']}\"}"

    response = http.request(request)
    @access_token = JSON.parse(response.read_body).values.first
    return @access_token
  end

  def add_tag
    url = URI('https://api.rd.services/platform/contacts')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{@access_token}}"
    request.body = "{\"tags\":[\"Videoaula_JohnBThompson_Jun23\"]}"

    response = http.request(request)
    puts response.read_body
  end

  def lead_params
    params.require(:lead).permit(:email, :name)
  end
end
