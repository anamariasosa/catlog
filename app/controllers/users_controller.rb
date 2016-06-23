class UsersController < ApplicationController

  before_filter :authenticate_user!, :only => [:dashboard]

  def show
    @user = User.find(params[:id])
    @products = @user.products.page(params[:page]).per(6).order('created_at DESC')
  end

  def dashboard

      if current_user.user_token?
        client = Instagram.client(:access_token => current_user.user_token)

        @options = { count: 40}
        @options[:max_id] = params[:max_id] if params[:max_id]

        @recent_media_items = client.user_recent_media("self", @options)

        if @recent_media_items.last.nil?
          @recent_media_items = client.user_recent_media
        end

        current_user.update(
          instagram_id:   client.user.id,
          store_image:    client.user.profile_picture,
          store_account:  client.user.username
        )
      else
        redirect_to edit_user_registration_path
      end



  end
end
