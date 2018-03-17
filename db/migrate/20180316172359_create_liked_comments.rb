class CreateLikedComments < ActiveRecord::Migration[5.1]
  def change
    create_table :liked_comments do |t|
      t.references :user, index: true
      t.references :comment, index: true
      t.timestamps
    end
  end
end
