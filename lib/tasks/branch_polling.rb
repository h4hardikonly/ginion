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
          puts "default queue size is #{default_queue.size}, waiting for queue to get empty before enqueuing new prs"
        else
          # green_branches = RemoteBranchTracker.green_branches
          # for now we are merging against master and 015_release but in future we should replace it with green branches
          pr_to_be_merged = PullRequest.pick_for_merge(against: GlobalConst::ALLOWED_MERGES_AGAINST)
          puts "enqueuing #{pr_to_be_merged.size} pull requests their ids #{pr_to_be_merged}"
          pr_to_be_merged.each do |pr_id|
            PrMergeWorker.perform_async pr_id
          end
        end
      rescue => e
        puts "#{e.class}:#{e.message}\n#{e.backtrace.join("\n")}"
      end
      sleep ENV['WAIT_TIME_BETWEEN_MERGE_ENQUEUE_TRY'] || GlobalConst::WAIT_TIME_BETWEEN_MERGE_ENQUEUE_TRY
    end
  end
end


default_queue = Sidekiq::Queue.all.find { |q| q.name == 'default' }
BranchPolling.new(default_queue).start
