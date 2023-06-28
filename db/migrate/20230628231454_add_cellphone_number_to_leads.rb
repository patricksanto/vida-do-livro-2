class AddCellphoneNumberToLeads < ActiveRecord::Migration[7.0]
  def change
    add_column :leads, :cellphone_number, :string
  end
end
