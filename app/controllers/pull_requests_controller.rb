class PullRequestsController < ApplicationController
  def create
    begin
      remote_pr = Ginion::PullRequest.remote_pr(params[:number])
    rescue Octokit::NotFound => e
      respond_to { |f| f.js { flash.now[:error] = "Pull Request #{params[:number]} not found" } }
      return
    end

    against = remote_pr.base.ref
    state = remote_pr.mergeable_state

    @pull_request = PullRequest.new(number: params[:number], queued_by: current_user, against: against)
    if remote_pr.state == 'closed'
      @pull_request.state = 'closed'
    else
      conflict = (remote_pr.mergeable_state == 'dirty')
      unstable = (remote_pr.mergeable_state == 'unstable')
    end

    @success = @pull_request.save
    if @success && (conflict || unstable)
      @pull_request.send(conflict ? :conflict : :unstable)
    else
      flash.now[:error] = @pull_request.errors.full_messages.to_sentence
    end
  end
end
