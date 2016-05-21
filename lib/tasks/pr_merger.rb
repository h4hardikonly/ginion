class PrMerger
  attr_reader :pr

  def initilize(pr)
    @pr = pr
  end

  def merge
    command_result = system("bin/lockit merge #{pr}") rescue nil
    pr.merged if command_result
  end
end
