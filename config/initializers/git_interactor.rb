GIT_INTERACTOR = Octokit::Client.new(access_token: (ENV['GIT_ACCESS_TOCKEN'] || Rails.application.secrets.git_access_tocken))
