class AddImagesAllToSerie < ActiveRecord::Migration[6.0]
  def change
    add_column :series, :images_all, :text
  end
end
