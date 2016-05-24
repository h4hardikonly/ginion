class CallbacksController < Devise::OmniauthCallbacksController
  def github
    login = request.env["omniauth.auth"]['extra']['raw_info']['login'] rescue nil
    logger.debug "user with login #{login} is trying to sign up via Git"
    if GIT_INTERACTOR.organization_member?('coupa', login)
      logger.debug "user is member of coupa org, granting access"
      @user = User.from_omniauth request.env["omniauth.auth"]
      sign_in_and_redirect @user
    else
      logger.debug "user is not member of coupa org, f**k off"
      # don't have access scsenario
    end
  end
end
