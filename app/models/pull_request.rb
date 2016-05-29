class PullRequest < ActiveRecord::Base
  belongs_to :queued_by, class_name: 'User'

  validates :against,     format: { with: GlobalConst::VALID_TARGET_BRANCHES_REGEXP, message: "PullRequest's target branch is not correct" }
  validates_presence_of   :queued_by_id
  validates_associated    :queued_by
  validates_uniqueness_of :number

  # check passed attributes and filter based on that
  scope :ready_to_merge, ->(against_branch_name) { where(state: 'open').where(against: (GlobalConst::ALLOWED_MERGES_AGAINST & against_branch_name)).order(created_at: :desc) }

  state_machine initial: :open do # open is known as clean in git
    event :merged do
      transition open: :merge_closed
    end

    event :reopen do
      transition closed: :open
    end

    event :conflict do
      transition open: :conflict
    end

    event :unstable do
      transition open: :unstable
    end
    # merged
  end

  def self.pick_for_merge(against:)
    against.inject([]) do |branch_array, against_branch_name|
      branch_array += ready_to_merge(against_branch_name).limit(GlobalConst::NUM_OF_ENQUEUE_PER_BRANCH_AT_TIME).pluck(:id)
    end
  end

  def against_locked_branch?
    UNLOCKED_BRANCHES.include?(against)
  end

  def queued_at
    created_at
  end
end
