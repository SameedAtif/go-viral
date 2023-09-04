class GigsController < ApplicationController
  def index
    @gigs = current_user.influencer.gigs.where(status: "approved")
  end

  def new
    @gig = Gig.new
    @gig.gig_platforms.build
  end

  def create
    @gig = Gig.new(permitted_params)
    @gig.influencer = current_user.influencer
    @gig.save!
    flash[:success] = 'Gig successfully created'
    redirect_to root_path
  rescue StandardError => e
    flash[:error] = e
    render 'new'
  end

  def show
    @gig = current_user.influencer.gigs.find_by(id: params[:gig_id])
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
      :id, :title,
      gig_categories_attributes: %i[id gig_id title description price delivery_estimation review_limit _destroy],
      gig_platforms_attributes: %i[id gig_id _destroy]
    )
  end
end
