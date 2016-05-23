class PullRequestsController < ApplicationController
  def create
    remote_pr = GIT_INTERACTOR.pull_request('coupa/coupa_development', params[:number])
    against = remote_pr.base.ref
    state = remote_pr.mergeable_state

    @pull_request = PullRequest.new(number: params[:number], queued_by: current_user, against: against)
    if remote_pr.mergeable_state == 'unknown'
      @pull_request.state = 'closed'
    else
      conflict = (mergeable_state == 'dirty')
      unstable = (mergeable_state == 'unstable')
    end

    @success = @pull_request.save
    if @success && (conflict || unstable)
      @pull_request.send(conflict ? :conflict : :unstable)
    else
      flash.now[:error] = @pull_request.errors.full_messages.to_sentence
    end
  end
end
