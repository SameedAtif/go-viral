class InfluencersController < ApplicationController
  before_action :find_influencer, only: %i[show edit update]
  def index
    @influencers = Influencer.all
  end

  def new
    @influencer = Influencer.new
    @influencer.influencer_platforms.build
  end

  def create
    @influencer = Influencer.new(permitted_params)
    @influencer.user_id = current_user.id
    if @influencer.save
      flash[:success] = 'influencer successfully created'
      session[:user_role] = 'Influencer'
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong'
      render 'new'
    end
  end

  def edit; end

  def show
    @influencer = Influencer.find_by(id: params[:id])
  end

  def update
    if @influencer.update(permitted_params)
      redirect_to @influencer
    else
      flash[:error] = 'Something went wrong'
      render 'edit'
    end
  end

  private

  def permitted_params
    params.require(:influencer).permit(:bio, influencer_platforms_attributes: %i[platform_id followers reach _destroy])
  end

  def find_influencer
    @influencer = Influencer.find_by(id: params[:id])
  end
end
