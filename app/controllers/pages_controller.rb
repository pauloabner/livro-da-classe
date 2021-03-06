class PagesController < ApplicationController
  before_filter :public_view_check
  layout        :choose_layout

  def home
  end

  def contact
    @name = params[:name]
    @email = params[:email]
    @content = params[:content]

    AdminMailer.contact_notifier(@name, @email, @content).deliver

    redirect_to root_path, :notice => 'Sua mensagem foi enviada.'
  end

  private

  def public_view_check
    redirect_to app_home_path if current_user
  end
end
