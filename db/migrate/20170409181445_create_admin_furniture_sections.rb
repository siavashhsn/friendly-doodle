class CreateAdminFurnitureSections < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_furniture_sections do |t|
      t.string :name
      t.string :comment
      t.json   :images

      t.timestamps
    end
  end
end
