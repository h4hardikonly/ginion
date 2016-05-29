class AddLastMergeTryAtToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :last_merge_try_at, :timestamps
    add_column :pull_requests, :merge_try_count, :integer, default: 0
    add_column :pull_requests, :last_sync_at, :timestamps
  end
end
