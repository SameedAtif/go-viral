class GigClientsController < ApplicationController
  before_action :set_gig_client, :validate_status, only: :update

  def update
    @gig_client.assign_attributes(permitted_params)
    authorize @gig_client
    @gig_client.save!
  end

  private

  def set_gig_client
    @gig_client = GigClient.find(params[:id])
  end

  def permitted_params
    params.require(:gig_client).permit(
      :status
    )
  end

  def valid_client_status?
    status = params.dig(:gig_client, :status)
    return true if status.blank?

    [::GigClient::STATUSES_MAP[:request_rolled_back]].include?(status)
  end

  def valid_influencer_status?
    status = params.dig(:gig_client, :status)
    return true if status.blank?

    [::GigClient::STATUSES_MAP[:accepted], ::GigClient::STATUSES_MAP[:rejected]].include?(status)
  end

  def verified_role(user_type)
    role = current_user.send(user_type)

    role.present? && session[:user_role] == User::USER_ROLES[user_type]
  end

  def validate_status
    return if (verified_role(:client) && valid_client_status?) || (verified_role(:influencer) && valid_influencer_status?)

    raise Pundit::NotAuthorizedError.new("Unauthorized value for column status")
  end
end
