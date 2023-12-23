class GigsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index manage_gigs]

  before_action :seller_navbar, except: %i[show index]
  before_action :load_gig, only: %i[show edit update]
  before_action :authorize_resource!, only: %i[edit update]
  before_action :validate_status, only: %i[create update]

  layout "pages_with_search_bar"

  # TODO: Rename gig_categories to gig_packages [D]
  # TODO: Add column to gig_packages: package features  [D]
  # TODO: Handle reviewer side of updation [D]
  # TODO: Add parmas authorization [D]
  # TODO: Add audience demographic (geographic and location)  [D]
  # TODO: Create client gig_review table + model [D]
  # TODO: Add remaining gig_package validation [D]
  # TODO: Add model validations [D]
  # TODO: Add column 'status [pending-review/accepted/rejected/payment-approved/influencer-credited/order-closed]' to gig_clients [D]
  # TODO: notifications [D]
  # TODO: Gig Order (will be handled through Gig Client) [D]
  # TODO: RSpec [D]
  # TODO: Create seed data [D]

  def index
    @gigs = Gig.all
  end

  def manage_gigs
    @gigs = current_user.influencer&.gigs&.left_outer_joins(:gig_clients) || []
  end

  def new
    @gig = Gig.new
    authorize @gig
    @gig.gig_platforms.build
    @gig.gig_packages.build
    @gig.gig_faqs.build
  end

  def create
    @gig = Gig.new(creation_params)
    @gig.influencer = current_user.influencer
    authorize @gig
    @gig.save!
    flash[:success] = 'Gig successfully created'
    redirect_to root_path
  end

  def show
  end

  def edit
    @gig.gig_platforms.build
    @gig.gig_packages.build
    @gig.gig_faqs.build
  end

  def update
    @gig.update!(permitted_params)
    flash[:success] = "Gig was successfully updated"
    redirect_to @gig
  end

  private

  def creation_params
    params.require(:gig).permit(
      :id, :title, :description, :targeted_demographic_start_age, :targeted_demographic_end_age,
      gig_packages_attributes: [:id, :title, :description, :price, :delivery_estimation, :review_limit, :_destroy, features: []],
      gig_platforms_attributes: %i[id platform_id _destroy],
      gig_faqs_attributes: %i[id question answer _destroy],
      targeted_geographic_audience: []
    )
  end

  def permitted_params
    params.require(:gig).permit(
      policy(@gig).permitted_attributes
    )
  end

  def load_gig
    @gig = Gig.find(params[:id])
  end

  def authorize_resource!
    authorize @gig
  end

  def valid_client_status?
    status = params.dig(:gig, :status)
    return true if status.blank?

    [::Gig::STATUSES_MAP[:published], ::Gig::STATUSES_MAP[:draft]].include?(status)
  end

  def valid_reviewer_status?
    status = params.dig(:gig, :status)
    return true if status.blank?

    [::Gig::STATUSES_MAP[:approved], ::Gig::STATUSES_MAP[:rejected]].include?(status)
  end

  def verified_role(user_type)
    role = current_user.send(user_type)

    role.present? && session[:user_role] == User::USER_ROLES[user_type]
  end

  def validate_status
    return if (verified_role(:client) && valid_client_status?) || (verified_role(:reviewer) && valid_reviewer_status?) || params.dig(:gig, :status).blank?

    raise Pundit::NotAuthorizedError.new("Unauthorized value for column status")
  end

  def seller_navbar
    @navbar = 'shared/navbar/seller_navbar'
  end
end
