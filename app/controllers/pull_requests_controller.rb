class PullRequestsController < ApplicationController
  def create
    
    c.pull_request('coupa/coupa_development', 1)
    PullRequest.create(number: params[:number], queued_by: current_user)
  end
end
