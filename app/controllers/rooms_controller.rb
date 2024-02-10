class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_status

  layout "pages_with_search_bar"

  def index; end

  def show
    @room = Room.find(params[:id])
    @other_participant_name = @room.participants.where.not(user_id: current_user).first.user.full_name
    @message = Message.new(room: @room, user: current_user)
    @messages = @room.messages
    respond_to do |format|
      format.js
    end
  end

  def create
    @room = Room.create(name: room_params[:name])
  end

  def new
    @room = Room.joins(participants: :user)
                .group('rooms.id')
                .having('COUNT(DISTINCT participants.id) = 2')
                .where(name: params[:name], is_private: true, participants: { user_id: [current_user.id, params[:participant_id]] })
                .distinct.first
    if @room.blank?
      @room = Room.new(name: params[:name], is_private: true)
      @room.participants << Participant.new(room: @room, user_id: current_user.id)
      @room.participants << Participant.new(room: @room, user_id: params[:participant_id])
      @room.save!
    end
    @other_participant_name = User.find(params[:participant_id]).full_name
    # TODO: Delete rooms with no messages.
    @message = Message.new(room: @room, user: current_user)
    @messages = @room.messages
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
