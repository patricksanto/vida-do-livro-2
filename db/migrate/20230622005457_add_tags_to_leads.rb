class AddTagsToLeads < ActiveRecord::Migration[7.0]
  def change
    add_column :leads, :tags, :string, array: true, default: []
  end
end
