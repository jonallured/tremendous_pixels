class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.belongs_to :target_tweet
      t.binary :data
      t.json :palette
      t.string :text
      t.timestamps
    end
  end
end
