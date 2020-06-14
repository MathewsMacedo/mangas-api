class CreateSeries < ActiveRecord::Migration[6.0]
  def change
    create_table :series do |t|
      t.integer :id_serie
      t.string :cover
      t.string :name
      t.string :categories
      t.integer :chapters
      t.text :description
      t.string :artist
      t.float :score
      t.boolean :is_complete
      t.string :lang
      t.text :chapters_all

      t.timestamps
    end
  end
end
