class CreateRelevantImages < ActiveRecord::Migration
  def self.up
    create_table :relevant_images do |t|
			t.string :username
			t.integer :relevance_count
			t.string :image_url
			t.datetime :posted_at
			t.integer :image_width
			t.integer :image_height
      t.timestamps
    end
  end

  def self.down
    drop_table :relevant_images
  end
end
