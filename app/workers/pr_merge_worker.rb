require "#{Rails.root}/lib/pr_merger.rb"

class PrMergeWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(pr_id)
    PrMerger.new(PullRequest.find(pr_id)).merge
  end
end
