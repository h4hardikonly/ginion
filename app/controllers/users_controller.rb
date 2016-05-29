class UsersController < ApplicationController
  before_action :authenticate_user! 

  def homepage
    @queued_prs  = PullRequest.where(queued_by: current_user, state: 'open')
    @stucked_prs = PullRequest.where(queued_by: current_user, state: ['conflict', 'unstable'])
    @merge_closed_prs   = PullRequest.where(queued_by: current_user, state: ['merge_closed'])
    @unmerge_closed_prs = PullRequest.where(queued_by: current_user, state: ['close_without_merge'])
  end
end
