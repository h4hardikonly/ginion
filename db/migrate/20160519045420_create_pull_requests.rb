class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.integer :number, index: true

      t.timestamps null: false
    end
  end
end
