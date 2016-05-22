module LockitInteractor
  def self.get_command(pr_number, force_merge: false, skip_solano: false, skip_jenkins: false, skip_teamcity: false)
    command = "bin/lockit merge #{pr_number}"
    # --skip-pending-status bypass pending status checks
    command << ' --force-merge'   if force_merge
    command << ' --skip-solano'   if skip_solano
    command << ' --skip-jenkins'  if skip_jenkins
    command << ' --skip-teamcity' if skip_teamcity
    command
  end
end
