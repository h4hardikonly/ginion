class Ginion::PullRequest
  attr_reader :local_pr_obj, :remote_pr_obj

  def initialize(local_pr_obj, options={})
    @local_pr_obj  = local_pr_obj
    @remote_pr_obj = options[:remote_pr_obj] || self.class.remote_pr(local_pr_obj.number)
  end

  def self.sync
    compare_assign_state(local_pr_obj, remote_pr_obj)
    # to get status of each checks of PR's last commit
    # https://octokit.github.io/octokit.rb/Octokit/Client/Statuses.html#combined_status-instance_method
    local_pr_obj.sync_complete
  end

  def self.remote_pr(pr_number)
    GIT_INTERACTOR.pull_request('coupa/coupa_development', pr_number)
  end

  def self.compare_assign_state
    if remote_pr_obj.state == 'closed'
      remote_pr_obj.merged ? local_pr_obj.merged : local_pr_obj.close_without_merge
    else
      case remote_state
      when 'conflict'
        local_pr_obj.conflict
      when 'unstable'
        local_pr_obj.unstable
      end
    end
  end
end
