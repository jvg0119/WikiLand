class AddSlugToWikis < ActiveRecord::Migration[5.0]
  def change
    add_column :wikis, :slug, :string
    add_index :wikis, :slug
  end
end
