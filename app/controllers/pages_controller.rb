class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :workshop, :submit]

  def home
  end

  def workshop
    @hide_navbar = true
    @lead = Lead.new
  end

  def submit
    # response = HTTParty.post('https://api.rd.services/platform/contacts',
    #                           headers: {
    #                             'Content-Type' => 'application/json',
    #                             'Authorization' => "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwaS5yZC5zZXJ2aWNlcyIsInN1YiI6InZ6RnpsS3daRDEwcTllZ21ldnkzRjNoM3QyZ1U0RlRhdHMtWFJ2UE9ZLTBAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vYXBwLnJkc3RhdGlvbi5jb20uYnIvYXBpL3YyLyIsImFwcF9uYW1lIjoiVmlkYSBkbyBMaXZybyIsImV4cCI6MTY4NzQwMDEzNywiaWF0IjoxNjg3MzEzNzM3LCJzY29wZSI6IiJ9.YMzn_4UV1KjPgwQkx-bb6Qk1r-ZIIMcEHwf5Q5i9uGOxiWcgLvKiM-2-Z7kXOIo2h_u0njDWNPkalvICBJvzLmNZ0P_A7p1RKppD9C2BR_1qkwy6bUOV2NLDZ-TKnuGGtkbYLrUl9UWoCnlekHC7RPir-bNWti7SRRoWQx2ZLLscQM3s-Ylq_gSMd318-fcAHNh4IqjUB2CE53_6wAAb5E5U9CtKl9tFCUpYuin4HYebBNbVFYNnX9M5GgelhjJuqS4jNy6GvERl1tG_IJuy7frJOS8DeDrFlZeINqlAIITRu2fkdprw-XIo1TxJG-_Y6wIJBg-R0LMNPstK3kMPuQ"
    #                           },
    #                           body: {
    #                             name: contact_params[:name],
    #                             email: contact_params[:email]
    #                           }.to_json)

    # if response.success?
    #   # Tratar o contato criado com sucesso
    #   redirect_to root_path, notice: 'Contato criado com sucesso!'
    # else
    #   # Tratar o erro de criação do contato
    #   redirect_to root_path, alert: 'Falha ao criar o contato!'
    # end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email)
  end
end
