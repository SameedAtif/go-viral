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

  def search
    query = params[:query].present? ? params[:query] : ''
    influencers = User.joins(:influencer).where('first_name LIKE ?', "%#{query}%").map { |influencer| { type: 'influencer', name: influencer.first_name + influencer.last_name, image_url: 'https://miro.medium.com/v2/resize:fill:176:176/1*MVIwhNJFsJ44bhmi-L8zrA.jpeg' } }
    platforms = Platform.where('name LIKE ?', "%#{query}%").map { |platform| { type: 'platform', name: platform.name, image_url: 'https://t3.ftcdn.net/jpg/04/74/05/94/360_F_474059464_qldYuzxaUWEwNTtYBJ44VN89ARuFktHW.jpg' } }
  
    results = influencers + platforms
  
    respond_to do |format|
      format.json { render json: results }
    end
  end
end
