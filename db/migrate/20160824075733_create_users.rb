class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|

    	t.string :username
      t.string :password 
      t.float :longitude, { precision: 10, scale: 6 }
      t.float :latitude, { precision: 10, scale: 6 }
      t.timestamps
    end
  end
end
