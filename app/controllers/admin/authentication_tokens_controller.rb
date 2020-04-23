class Admin::AuthenticationTokensController < ApplicationController
  def index
    @tokens = current_user.authentication_tokens
  end

  def create
    friendly_token = Tiddle.create_and_return_token(current_user, request)
    logger.info friendly_token

    redirect_to(
      admin_authentication_tokens_path,
      notice: I18n.t('activerecord.authentication_tokens.created', token: friendly_token)
    )
  end

  def destroy
    AuthenticationToken.find(params[:id]).destroy
    redirect_to admin_authentication_tokens_path
  end
end
