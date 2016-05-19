class UsersController < ApplicationController
  before_action :authenticate_user! 

  def homepage
    @prs = PullRequest.where(queued_by: current_user)
  end
end
