class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from ActionController::RoutingError, with: :redirect_to_root

  def redirect_to_root
    puts "Redirecting to root"
    redirect_to root_path
  end
end
