class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, presence: true
      t.index :email, unique: true
      t.string :password_digest

      t.timestamps
    end
  end
end
