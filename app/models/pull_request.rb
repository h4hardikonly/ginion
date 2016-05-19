class PullRequest < ActiveRecord::Base
  validates_uniqueness_of :number
  belongs_to :queued_by, class_name: 'User'
end
