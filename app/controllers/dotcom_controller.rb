class DotcomController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end
  def dashboard; end
end
