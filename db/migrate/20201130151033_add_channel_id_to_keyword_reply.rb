class AddChannelIdToKeywordReply < ActiveRecord::Migration[6.0]
  def change
    add_column :keyword_mappings, :channel_id, :string
  end
end
