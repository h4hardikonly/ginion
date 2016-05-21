class PullRequest < ActiveRecord::Base
  validates_uniqueness_of :number
  belongs_to :queued_by, class_name: 'User'

  # check passed attributes and filter based on that
  scope :ready_to_merge, -> { where(state: 'open').where(against: ALLOWED_MERGES_AGAINST).order(created_at: :desc) }

  state_machine initial: :open do
    event :merged do
      transition open: :merge_closed
    end

    event :reopen do
      transition closed: :open
    end
  end

  def self.map_ready_to_merge(options={})
    ready_to_merge.pluck(:id)
  end

  def queued_at
    created_at
  end
end
