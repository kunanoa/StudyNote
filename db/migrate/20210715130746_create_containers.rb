class CreateContainers < ActiveRecord::Migration[5.2]
  def change
    create_table :containers do |t|

      t.timestamps
    end
  end
end
