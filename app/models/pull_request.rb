class PullRequest < ActiveRecord::Base
  validates_uniqueness_of :number
  belongs_to :queued_by, class_name: 'User'

  scope :ready_for_merge, -> { order(created_at: :desc) }

  state_machine initial: :open do
    event :merged do
      transition open: :merge_closed
    end
  end

  def queued_at
    created_at
  end
end
