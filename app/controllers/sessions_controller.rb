class SessionsController < ApplicationController

  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
    session[:access_token] = response.access_token

    client = Instagram.client(:access_token => session[:access_token])

    if  User.exists?(:instagram_id => client.user.id)
      flash[:notice] = "@#{client.user.username } Ya tienes una cuenta con nosotros. Inicia sesión con tus datos"
      redirect_to "/users/sign_in"
    else
      redirect_to "/users/sign_up"
    end
  end

end
