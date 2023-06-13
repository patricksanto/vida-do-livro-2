class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :workshop]

  def home
  end

  def workshop
    @hide_navbar = true
  end
end
