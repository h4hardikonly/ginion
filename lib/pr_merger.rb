require_relative 'lockit_interactor'
require "#{Rails.root}/lib/git/pull_request"

class PrMerger
  attr_reader :pr

  def initialize(pr)
    @pr = pr
  end

  def merge
    pr.trying_to_merge
    cmd = lockit_command
    command_result_success = system(cmd) rescue nil
    puts "#{command_result_success ? 'success' : 'failed'} for PR##{pr.id} executed command \"#{cmd}\""

    if command_result_success
      pr.merged
    else
      Ginion::PullRequest.new(pr).sync
    end
  end

  private

  def force_merge?
    false
  end

  def skip_solano?
    false
  end

  def skip_jenkins?
    false
  end

  def skip_teamcity?
    false
  end

  def lockit_command
    LockitInteractor.get_command(
      pr.number,
      force_merge:   force_merge?,
      skip_solano:   skip_solano?,
      skip_jenkins:  skip_jenkins?,
      skip_teamcity: skip_teamcity?
    )
  end
end
