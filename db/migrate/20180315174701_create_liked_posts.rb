class CreateLikedPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :liked_posts do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.timestamps
    end
  end
end
