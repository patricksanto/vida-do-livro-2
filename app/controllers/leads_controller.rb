class LeadsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :waiting_list]

  def new
    @lead = Lead.new
    @hide_navbar = true
  end

  def waiting_list
    create_lead_and_redirect
  end

  def create
    create_lead_and_redirect
  end

  private

  def create_lead_and_redirect
    @lead = Lead.find_or_initialize_by(email: lead_params[:email])
    @lead.assign_attributes(lead_params)
    @lead.tags << lead_params[:tags]
    @lead.save!

    url = URI('https://api.rd.services/platform/contacts')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{refresh_token}"
    request.body = { name: @lead.name, email: @lead.email, tags: @lead.tags }.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      flash[:notice] = 'Email cadastrado na lista de espera'
      redirect_to root_path(anchor: 'form')
    elsif response.is_a?(Net::HTTPClientError) && JSON.parse(response.body)["errors"]["error_type"] == "EMAIL_ALREADY_IN_USE"
      handle_existing_lead
    else
      render :new, status: :unprocessable_entity
    end
  end

  def handle_existing_lead
    encoded_email = URI.encode_www_form_component(@lead.email)
    url = URI("https://api.rd.services/platform/contacts/email:#{encoded_email}/tag")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request['Authorization'] = "Bearer #{refresh_token}"
    request.body = "{\"tags\":[\"#{@lead.tags.last}\"]}"

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      flash[:notice] = 'Aproveite a masterclass!'
      redirect_to ofuturodolivro_masterclass_path(anchor: 'workshopform')
    else
      render :new, status: :unprocessable_entity
    end
  end

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
  end

  def lead_params
    params.require(:lead).permit(:email, :name, :cellphone_number, :tags)
  end
end
