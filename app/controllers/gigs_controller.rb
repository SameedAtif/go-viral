class GigsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index]

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
    @gigs = Gig.includes(:gig_platforms)
    
    @gigs = @gigs.joins(:gig_platforms).where(gig_platforms: { platform_id: params[:platform] }) if params[:platform].present?
    @gigs = @gigs.joins(:gig_categories).where(gig_categories: { category_id: params[:category] }) if params[:category].present?
    @gigs = @gigs.where(targeted_geographic_audience: params[:country]) if params[:country].present?
  
    if params[:date_filter_option].present? && params[:date_filter_option].is_a?(Array)
      selected_options = params[:date_filter_option]
      @gigs = case
              when selected_options.include?("last_24_hours")
                @gigs.where("gigs.created_at >= ?", 24.hours.ago)
              when selected_options.include?("last_week")
                @gigs.where("gigs.created_at >= ?", 1.week.ago)
              when selected_options.include?("last_month")
                @gigs.where("gigs.created_at >= ?", 1.month.ago)
              else
                @gigs
              end
    end
  
    @platforms = Platform.all
    @categories = Category.all
  
    @gigs = @gigs.page(params[:page]).per(20)
  
    respond_to do |format|
      format.html
      format.js
    end
  end  

  def manage_gigs
    @gigs = current_user.influencer&.gigs&.left_outer_joins(:gig_clients)&.distinct || []
  end

  def new
    @gig = Gig.new
    authorize @gig
    @gig.gig_platforms.build
    @gig.gig_packages.build
    @gig.gig_faqs.build
    @gig.gig_categories.build
  end

  def create
    # TODO: Bug -> User should be able to see validation failures and contineu from that point.
    @gig = Gig.new(creation_params)
    @gig.influencer = current_user.influencer
    @gig.status = params["draft"].present? ? Gig::STATUSES_MAP[:draft] : Gig::STATUSES_MAP[:pending_review]
    authorize @gig
    @gig.save!
    flash[:success] = 'Gig successfully created'
    redirect_to manage_gigs_gigs_path
  end

  def show
    @influencer = @gig.influencer
    @influencer_rating = @influencer.gigs.joins(:client_gig_reviews).average(:rating) || 'Just started'
    @influencer_ongoing_orders = @influencer.gigs.joins(:gig_clients).where(gig_clients: {status: GigClient::STATUSES_MAP[:accepted] }).count
    @influencer_completed_orders = @influencer.gigs.joins(:influencer_gig_transactions).count
    @gig_last_delivery = @gig.influencer_gig_transactions.last&.created_at
    @total_gig_reviews = @gig.client_gig_reviews.count
    if verified_role.respond_to?(:organization)
      @gig_relevance = OrganizationInfluencerMatchingService.new(
        org_id: verified_role.organization.id,
        influencer_id: @influencer.id,
        gig_id: @gig.id
      ).match
    end
  end

  def edit; end

  def update
    # TODO: Bug -> Cannot updated feature: Unpermitted param
    if @gig.reviewed
      @gig.status = params["draft"].present? ? Gig::STATUSES_MAP[:draft] : Gig::STATUSES_MAP[:published]
    else
      @gig.status = params["draft"].present? ? Gig::STATUSES_MAP[:draft] : Gig::STATUSES_MAP[:pending_review]
    end
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
      gig_categories_attributes: %i[id category_id _destroy],
      gig_faqs_attributes: %i[id question answer _destroy],
      targeted_geographic_audience: [],
      targeted_geographic_audience_city: []
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

  def is_verified_role(user_type)
    role = current_user.send(user_type)

    role.present? && session[:user_role] == User::USER_ROLES[user_type]
  end

  def validate_status
    return if (is_verified_role(:client) && valid_client_status?) || (is_verified_role(:reviewer) && valid_reviewer_status?) || params.dig(:gig, :status).blank?

    raise Pundit::NotAuthorizedError.new("Unauthorized value for column status")
  end

  def seller_navbar
    @navbar = 'shared/navbar/seller_navbar'
  end
end
