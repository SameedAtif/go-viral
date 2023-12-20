class Bulk::GigsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[destroy]

  # before_action :authorize_resources!, only: %i[update]
  # before_action :validate_status, only: %i[update]

  def destroy
    Gig.where(id: params[:gigs]).destroy_all
    redirect_back fallback_location: root_path
  end
end
