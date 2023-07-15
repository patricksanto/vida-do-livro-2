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

    if @lead.save
      token = refresh_token

      # url = URI('https://api.rd.services/platform/contacts')
      url = URI("https://api.rd.services/platform/events?event_type=conversion")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request['Accept'] = 'application/json'
      request['Content-Type'] = 'application/json'
      request['Authorization'] = "Bearer #{token}"
      if @lead.cellphone_number.present?
        request.body = { event_type: "CONVERSION", event_family: "CDP",
                         payload: {
                           name: @lead.name, email: @lead.email,
                           tags: @lead.tags, mobile_phone: @lead.cellphone_number,
                           conversion_identifier: "ofuturodolivro_masterclass"
                                  } }.to_json
      else
        request.body = { event_type: "CONVERSION", event_family: "CDP",
                         payload: {
                           name: @lead.name, email: @lead.email, tags: @lead.tags,
                           conversion_identifier: "ofuturodolivro_masterclass"
                                  } }.to_json
      end

      response = http.request(request)
      puts JSON.parse(response.body)

      if response.is_a?(Net::HTTPSuccess)
        flash[:notice] = notice_message
        redirect_to redirect_path
      elsif response.is_a?(Net::HTTPClientError) && JSON.parse(response.body)["errors"]["error_type"] == "EMAIL_ALREADY_IN_USE"
        handle_existing_lead(token)
      else
        render :new, status: :unprocessable_entity
      end

    else
      render :new, status: :unprocessable_entity
    end

  end

  def handle_existing_lead(tkn)
    encoded_email = URI.encode_www_form_component(@lead.email)

    url = URI("https://api.rd.services/platform/contacts/email:#{encoded_email}/tag")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request['Authorization'] = "Bearer #{tkn}"
    request.body = { tags: @lead.tags.last }.to_json
    # request.body = "{\"tags\":[\"#{@lead.tags.last}\"]}"
    response = http.request(request)
    puts response.read_body

    # phone_url = URI("https://api.rd.services/platform/contacts/email:#{encoded_email}")
    # phone_http = Net::HTTP.new(phone_url.host, phone_url.port)
    # phone_http.use_ssl = true

    # phone_request = Net::HTTP::Get.new(phone_url)
    # phone_request["accept"] = 'application/json'
    # phone_request["content-type"] = 'application/json'
    # phone_request['Authorization'] = "Bearer #{tkn}"
    # phone_request.body = { phone_number: @lead.cellphone_number }.to_json

    # phone_response = phone_http.request(phone_request)
    # puts phone_response.read_body


    if response.is_a?(Net::HTTPSuccess)
      flash[:notice] = notice_message
      redirect_to redirect_path
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

  def redirect_path
    if lead_params[:tags] == 'vdl_proximoscursos_jul23'
      root_path(anchor: 'form')
    else
      ofuturodolivro_masterclass_path(anchor: 'workshopform')
    end
  end

  def notice_message
    if lead_params[:tags] == 'vdl_proximoscursos_jul23'
      'Obrigado pelo interesse!'
    else
      'Aproveite a masterclass! Você também receberá a aula em seu email.'
    end

  end
end
