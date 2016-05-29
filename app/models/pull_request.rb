class PullRequest < ActiveRecord::Base
  belongs_to :queued_by, class_name: 'User'

  validates :against,     format: { with: GlobalConst::VALID_TARGET_BRANCHES_REGEXP, message: "PullRequest's target branch is not correct" }
  validates_presence_of   :queued_by_id
  validates_associated    :queued_by
  validates_uniqueness_of :number

  # check passed attributes and filter based on that
  scope :ready_to_merge, ->(against_branch_name) { 
    where(state: 'open').where(against: GlobalConst::ALLOWED_MERGES_AGAINST.find{|branch| branch == against_branch_name}).order(created_at: :desc)
  }

  state_machine initial: :open do # 'clean'
    event :merged do
      transition all => :merge_closed
    end

    event :close_without_merge do
      transition all => :unmerge_closed
    end

    event :reopen do
      transition all => :open
    end

    event :conflict do # 'dirty'
      transition all => :conflict
    end

    event :unstable do # 'unstable'
      transition all => :unstable
    end
  end

  def self.pick_for_merge(against:)
    against.inject([]) do |branch_array, against_branch_name|
      branch_array += ready_to_merge(against_branch_name).limit(GlobalConst::NUM_OF_ENQUEUE_PER_BRANCH_AT_TIME).pluck(:id)
    end
  end

  def against_locked_branch?
    UNLOCKED_BRANCHES.exclude?(against)
  end

  def queued_at
    created_at
  end

  def trying_to_merge
    update_last_merge_try_at
    increment_merge_try_count
  end

  def update_last_merge_try_at
    update_attribute(:last_merge_try_at, Time.now)
  end

  def increment_merge_try_count
    update_attribute(:merge_try_count, merge_try_count + 1)
  end

  def sync_complete
    self.update_attribute :last_sync_at, Time.now
  end
end
