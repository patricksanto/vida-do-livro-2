class Lead < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  # validates :cellphone_number, format: { with: /\A\d{10,12}\z/, message: "Insira um número de telefone válido" }

end
