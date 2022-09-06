class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, :id => false, :primary_key  => :id do |t|
      t.string :id, null: false
      t.string :user, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
