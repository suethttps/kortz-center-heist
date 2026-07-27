class AddGuideUrlToEntryPoints < ActiveRecord::Migration[8.1]
  def change
    add_column :entry_points, :guide_url, :string
  end
end
