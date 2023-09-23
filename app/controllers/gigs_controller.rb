class GigsController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'pages_with_search_bar'
  
  def index
    @gigs = Gig.all
  end

  def create
    @gig = Gig.new(permitted_params)
    if @gig.save
      flash[:success] = "gig successfully created"
      redirect_to @gig
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def show
    @gig = Gig.find(params[:gig_id])
  end

  def update
    @gig = Gig.find(params[:id])
    if @gig.update_attributes(permitted_params)
      flash[:success] = "Gig was successfully updated"
      redirect_to @gig
    else
      flash[:error] = "Something went wrong"
      render 'edit'
    end
  end

  def destroy
    @gig = Gig.find(params[:id])
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
    # Change later
    params.require(:gig).permit!
  end
end
