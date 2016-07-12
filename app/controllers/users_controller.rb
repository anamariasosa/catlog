class UsersController < ApplicationController

  before_filter :authenticate_user!, :only => [:dashboard]

  def show
    @user = User.find_by(slug: params[:id])
    @products = @user.products.page(params[:page]).per(24).order('created_at DESC')
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end

  end

  def oauth_failure
  end

  def dashboard

      if current_user.user_token?
        client = Instagram.client(:access_token => current_user.user_token)

        @options = { count: 40}
        @options[:max_id] = params[:max_id] if params[:max_id]
        @media = client.user_recent_media("self", @options)

        if @media.last.nil?
          @media = client.user_recent_media
        end

        current_user.update(
          instagram_id:   client.user.id,
          store_image:    client.user.profile_picture,
          store_account:  client.user.username,
          slug:           client.user.username
        )
      else
        redirect_to edit_user_registration_path
      end



  end
end
