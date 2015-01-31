class CreateGraduates < ActiveRecord::Migration
  def change
    create_table :graduates do |t|
      t.string :name
      t.string :current_location
      t.string :current_employer
      t.string :longitude
      t.string :latitude

      t.timestamps null: false
    end
  end
end
