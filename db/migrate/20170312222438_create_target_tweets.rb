class CreateTargetTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :target_tweets do |t|
      t.string :twitter_id
      t.string :full_text
      t.timestamps
    end
  end
end
