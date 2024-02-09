class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_status

  layout "pages_with_search_bar"

  def index; end

  def show
    @single_room = Room.find(params[:id])

    @room = Room.new
    @rooms = Room.public_rooms

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)

    @influencers = Influencer.all_except(current_user)
    render 'index'
  end

  def create
    @room = Room.create(name: room_params[:name])
  end

  def new
    @room = Room.new
    respond_to do |format|
      format.js
    end
  end

  def set_status
    current_user.update!(status: User.statuses[:online]) if current_user
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
