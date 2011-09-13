class AddTweetUrlToRelevantImage < ActiveRecord::Migration
  def self.up
		change_table :relevant_images do |t|
			t.string :tweet_url
		end
  end

  def self.down
		change_table :relevant_images do |t|
			t.remove :tweet_url
		end
  end
end
