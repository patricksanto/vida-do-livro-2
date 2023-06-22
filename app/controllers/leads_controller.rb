class LeadsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create]
  def new
    @lead = Lead.new
    @hide_navbar = true
  end

  def create
    @lead = Lead.new(lead_params)
    raise
    url = URI('https://api.rd.services/platform/contacts')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{ENV['ACCESS_TOKEN']}"
    request.body = { name: @lead.name, email: @lead.email, tags: 'Videoaula_JohnBThompson_Jun23' }.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      # Lógica para lidar com o resultado da criação do contato
      redirect_to root_path, notice: 'Contato criado com sucesso!'
    else
      flash.now[:error] = 'Erro ao criar o contato. Verifique os campos abaixo.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:email, :name)
  end
end
