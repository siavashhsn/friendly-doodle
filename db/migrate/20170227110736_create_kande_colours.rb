class CreateKandeColours < ActiveRecord::Migration[5.0]
  def change
    create_table :kande_colours do |t|
      t.json :details
      t.float :cost

      t.timestamps
    end
  end
end
