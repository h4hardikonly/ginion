class CallbacksController < Devise::OmniauthCallbacksController
  def github
    login = request.env["omniauth.auth"]['extra']['raw_info']['login'] rescue nil
    if GIT_INTERACTOR.organization_member?('coupa', login)
      @user = User.from_omniauth request.env["omniauth.auth"]
      sign_in_and_redirect @user
    else
      # don't have access scsenario
    end
  end
end
