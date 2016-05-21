class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.integer :number, index: true
      t.integer :queued_by_id, index: true, foreign_key: true
      t.string  :state, index: :true

      t.timestamps null: false
    end
  end
end
