class BranchPolling
end

Thread.new do
  while true
    # if sidekiq.que is empty
      PullRequest.ready_for_merge.each do |pr|
        PrMerger.new(pr)
      end
    # end
    sleep WAIT_TIME_BETWEEN_MERGE_ENQUEUE_TRY
  end
end
