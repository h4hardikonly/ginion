module PullRequestsHelper
  def required_action_text(pr)
    case pr.state
    when 'conflict'
      "Pull Request in conflict with #{pr.against}, please rebase and solve conflicts"
    when 'unstable'
      'One of the check is failing for pull request'
    end
  end
end
