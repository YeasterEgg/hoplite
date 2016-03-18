class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    I18n.locale = :it
  end

  def destroy_all
  	Sale.destroy_all
  	Product.destroy_all
  	redirect_to products_path
  end

end
