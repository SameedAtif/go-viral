class GigsController < ApplicationController
  skip_before_action :authenticate_user!
  layout "pages_with_search_bar"
  
  def index
    @gigs = Gig.approved
  end

  def new
    @gig = Gig.new
    authorize @gig
    @gig.gig_platforms.build
  end

  def create
    @gig = Gig.new(permitted_params)
    @gig.influencer = current_user.influencer
    authorize @gig
    @gig.save!
    flash[:success] = 'Gig successfully created'
    redirect_to root_path
  end

  def show
    @gig = Gig.find_by(id: params[:gig_id])
  end

  def edit
    @gig = current_user.influencer.gigs.find_by(id: params[:id])
  end

  def update
    @gig = current_user.influencer.gigs.find_by(id: params[:id])
    if @gig.update_attributes(permitted_params)
      flash[:success] = "Gig was successfully updated"
      redirect_to @gig
    else
      flash[:error] = "Something went wrong"
      render 'edit'
    end
  end

  def destroy
    @gig = current_user.influencer.gigs.find_by(id: params[:id])
    if @gig.destroy
      flash[:success] = 'Gig was successfully deleted.'
      redirect_to gigs_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to gigs_url
    end
  end

  private

  def permitted_params
    params.require(:gig).permit(
      :id, :title, :description,
      gig_categories_attributes: %i[id gig_id title description price delivery_estimation review_limit _destroy],
      gig_platforms_attributes: %i[id gig_id _destroy],
      gig_faqs_attributes: %i[id gig_id question answer]
    )
  end
end
