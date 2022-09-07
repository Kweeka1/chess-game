class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :user_guid, null: false
      t.string :user, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
