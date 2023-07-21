class Lead < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  # validates :cellphone_number, format: { with: /\A\d{10,12}\z/, message: "Insira um número de telefone válido" }
  validates :cellphone_number, length: { in: 10..12 }, allow_blank: true
  validates_numericality_of :cellphone_number, only_integer: true, allow_blank: true, length: { in: 10..12 }
end
