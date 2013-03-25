class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references :twitter_user
      t.string :content
      t.datetime :twitter_created_at
      t.timestamps
    end
  end
end
