class InfluencersController < ApplicationController
  def index
    @influencers = Influencer.all
  end

  def create
    @influencers = Influencer.new(permitted_params)
    if @influencers.save
      flash[:success] = "gig successfully created"
      redirect_to @influencers
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def show
    @influencers = Influencer.find(params[:gig_id])
  end

  def update
    @influencers = Influencer.find(params[:id])
    if @influencers.update_attributes(permitted_params)
      flash[:success] = "Influencer was successfully updated"
      redirect_to @influencers
    else
      flash[:error] = "Something went wrong"
      render 'edit'
    end
  end

  def destroy
    @influencers = Influencer.find(params[:id])
    if @influencers.destroy
      flash[:success] = 'Influencer was successfully deleted.'
      redirect_to influencers_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to influencers_url
    end
  end

  private

  def permitted_params
    # Change later
    params.require(:influencer).permit!
  end
end
