class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.string :title
      t.string :finder
      t.text :description
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
