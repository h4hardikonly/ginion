class PullRequestsController < ApplicationController
  def create
    PullRequest.create(number: params[:number], queued_by: current_user)
  end
end
