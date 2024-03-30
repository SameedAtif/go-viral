class DotcomController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @gigs = Gig.limit(10)
  end
  def dashboard; end

  def search
    query = params[:query].present? ? params[:query] : ''

    results = if query.present?
      influencers = User.joins(:influencer).where(
        "first_name ILIKE ? OR last_name ILIKE ? OR influencers.stage_name ILIKE ?",
        "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%"
      ).map { |influencer| { id: influencer.id, type: 'influencer', name: influencer.first_name + influencer.last_name, image_url: 'https://miro.medium.com/v2/resize:fill:176:176/1*MVIwhNJFsJ44bhmi-L8zrA.jpeg' } }
      platforms = Platform.where('name LIKE ?', "%#{query}%").map { |platform| { type: 'platform', name: platform.name, image_url: 'https://t3.ftcdn.net/jpg/04/74/05/94/360_F_474059464_qldYuzxaUWEwNTtYBJ44VN89ARuFktHW.jpg' } }

      influencers + platforms
    else
      []
    end
    respond_to do |format|
      format.json { render json: results }
    end
  end
end
