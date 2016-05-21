class BranchPolling
end

Thread.new do
  while true
    # if sidekiq.que is empty
      # green_branches = RemoteBranchTracker.green_branches
      PullRequest.map_ready_to_merge(against: 'green_branches').each do |pr|
        # instead follwoing queue
        PrMergeWorker.perform_async pr.id
      end
    # end
    sleep WAIT_TIME_BETWEEN_MERGE_ENQUEUE_TRY
  end
end
