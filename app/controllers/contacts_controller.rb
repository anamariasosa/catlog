class ContactsController < ApplicationController
  layout :determine_layout

  def new
    @contact = Contact.new
    populate_data
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:error] = t('mail_form.success')
    else
      flash.now[:error] = t('mail_form.error')
      render :new
    end
  end

  private
    def populate_data
      if user_signed_in?
        @email = current_user.email
        if current_user.type == "Store"
          @name = current_user.name
        else
          @name = current_user.full_name
        end
      end
    end

    def determine_layout
      if user_signed_in? and not current_user.email.blank?
        "dashboard"
      else
         "application"
       end
    end
end
