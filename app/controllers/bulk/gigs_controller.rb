class Bulk::GigsController < ApplicationController
  def destroy
    permitted_gigs.where(id: params[:gigs]).destroy_all
    redirect_back fallback_location: root_path
  end

  private

  def permitted_gigs
    raise Pundit::NotAuthorizedError.new("Unauthorized value for column status") unless current_user.admin? || current_user.influencer?

    @permitted_gigs ||= if current_user.admin?
                          Gig.all
                        else
                          current_user.influencer.gigs
                        end
  end
end
