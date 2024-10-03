class HomeController < ApplicationController
  def index
    redirect_to new_pastedatum_path
  end
end
