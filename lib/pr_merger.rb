require_relative 'lockit_interactor'

class PrMerger
  attr_reader :pr

  def initialize(pr)
    @pr = pr
  end

  def merge
    command_result = system(lockit_command) rescue nil
    # success:false PR#1 executed command bin/lockit merge 111
    puts "#{command_result ? 'success' : 'failed'} for PR##{pr.id} executed command \"#{lockit_command}\""
    pr.merged if command_result
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
