class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.boolean :display, :null => false
      t.boolean :validated, :null => false
      t.integer :likes, :null => false
      t.integer :dislikes, :null => false
      t.references :post, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :comment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
