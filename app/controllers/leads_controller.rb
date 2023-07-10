class LeadsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create, :waiting_list]

  def new
    @lead = Lead.new
    @hide_navbar = true
  end

  # def initialize
  #   @access_token = ''
  # end

  def waiting_list
    @lead = Lead.find_or_initialize_by(email: lead_params[:email])
    @lead.assign_attributes(lead_params)
    @lead.tags << lead_params[:tags]

    # redirect_to root_path if consult_lead

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
      result = JSON.parse(response.body)
      puts result
      flash[:notice] = 'Email cadastrado na lista de espera'
      redirect_to root_path(anchor: 'form')
    else
      if @lead.save
        # redirect_to root_path, notice: 'Aproveite o workshop!'
        p 'Lead salvo so na DB local'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def create
    @lead = Lead.find_or_initialize_by(email: lead_params[:email])
    @lead.assign_attributes(lead_params)
    @lead.tags << lead_params[:tags]

    # redirect_to root_path if consult_lead

    url = URI('https://api.rd.services/platform/contacts')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{refresh_token}"
    request.body = { name: @lead.name, email: @lead.email, tags: @lead.tags }.to_json

    response = http.request(request)
    puts JSON.parse(response.body)

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      puts result
      flash[:notice] = 'Aproveite a masterclass!'
      redirect_to ofuturodolivro_masterclass_path(anchor: 'workshopform')
    else
      if (JSON.parse(response.body)["errors"]["error_type"] == "EMAIL_ALREADY_IN_USE")

        encoded_email = URI.encode_www_form_component(@lead.email)
        url = URI("https://api.rd.services/platform/contacts/email:#{encoded_email}/tag")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["accept"] = 'application/json'
        request["content-type"] = 'application/json'
        request['Authorization'] = "Bearer #{refresh_token}"
        request.body = "{\"tags\":[\"videoaula_johnbthompson_jun23\"]}"

        response2 = http.request(request)
        puts response.read_body

        if response2.is_a?(Net::HTTPSuccess)
          flash[:notice] = 'Aproveite a masterclass!'
          redirect_to ofuturodolivro_masterclass_path(anchor: 'workshopform')
        else
          render :new, status: :unprocessable_entity
        end
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

  def consult_lead
    email = lead_params[:email]
    encoded_email = URI.encode_www_form_component(email)
    url = URI("https://api.rd.services/platform/contacts/email:#{encoded_email}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["authorization"] = "Bearer #{refresh_token}"

    response = http.request(request)

    # RETURN TRUE IF LEAD EXISTS
    response.is_a?(Net::HTTPNotFound) ? false : true


  end

  def lead_params
    params.require(:lead).permit(:email, :name, :cellphone_number, :tags)
  end
end
