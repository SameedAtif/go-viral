class DotcomController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @gigs = Gig.limit(10)
  end
  def dashboard; end
  def search
    if params[:query].present?
      @influencers = User.joins(:influencer).where('first_name LIKE ?', "%#{params[:query]}%")
    else
      @influencers = Influencer.none
    end

    respond_to do |format|
      format.json { render json: @influencers }
    end
  end
end
