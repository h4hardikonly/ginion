class UsersController < ApplicationController
  before_action :authenticate_user! 

  def homepage
    @queued_prs = PullRequest.where(queued_by: current_user, state: 'open')
    @prs = PullRequest.where(queued_by: current_user, state: ['conflict', 'unstable'])
  end
end
