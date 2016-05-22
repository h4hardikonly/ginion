require 'sidekiq/api'

class BranchPolling
  attr_reader :default_queue, :logger

  def initialize(default_queue)
    @default_queue = default_queue
    @logger = Logger.new('log/branch_polling.log')
  end

  def start
    while true
      begin
        if default_queue && default_queue.size > 0
          logger.debug "default queue size is #{default_queue.size}, waiting for queue to get empty before enqueuing new prs"
        else
          # green_branches = RemoteBranchTracker.green_branches
          pr_to_be_merged = PullRequest.pick_for_merge(against: 'green_branches')
          logger.debug "enqueuing #{pr_to_be_merged.size} pull requests"
          pr_to_be_merged.each do |pr_id|
            PrMergeWorker.perform_async pr_id
          end
        end
      rescue => e
        logger.error "#{e.class}:#{e.message}\n#{e.backtrace.join("\n")}"
      end
      sleep GlobalConst::WAIT_TIME_BETWEEN_MERGE_ENQUEUE_TRY
    end
  end
end


default_queue = Sidekiq::Queue.all.find { |q| q.name == 'default' }
BranchPolling.new(default_queue).start
