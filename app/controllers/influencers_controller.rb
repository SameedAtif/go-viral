class InfluencersController < ApplicationController
  layout "pages_with_search_bar"

  before_action :find_influencer, only: %i[show edit update]

  def index
    @influencers = Influencer.all
  end

  def new
    @influencer = Influencer.new
    @influencer.influencer_platforms.build
  end

  def create
    # TODO: Bug -> Two requests were sent to this.
    @influencer = Influencer.new(permitted_params)
    @influencer.user_id = current_user.id
    if @influencer.save
      flash[:success] = 'influencer successfully created'
      session[:user_role] = User::USER_ROLES[:influencer]
      redirect_to manage_gigs_gigs_path
    else
      flash[:error] = @influencer.errors.full_messages.join(',')
      render 'new'
    end
  end

  def edit; end

  def show
    @influencer = Influencer.find_by(id: params[:id])
    @gigs = @influencer.gigs
    @rooms = Room.public_rooms
    @room = Room.new
    @message = Message.new
    @room_name =  Room.get_name(@influencer)
    @single_room = Room.find_or_create_by!(name: @room_name)
    @messages = @single_room.messages
  end

  def update
    if @influencer.update(permitted_params)
      redirect_to @influencer
    else
      flash[:error] = @influencer.errors.full_messages.join(',')
      render 'edit'
    end
  end

  private

  def permitted_params
    params.require(:influencer).permit(:avatar, :bio, :stage_name,
      influencer_platforms_attributes: [:id, :platform_id, :followers, :reach, :url, :targeted_demographic_start_age, :targeted_demographic_end_age, :_destroy, targeted_geographic_audience: [], targeted_geographic_audience_city: []],
      influencer_portfolios_attributes: %i[id title description start_time end_time content_link _destroy]
    )
  end

  def find_influencer
    @influencer = Influencer.find_by(id: params[:id])
  end

end
