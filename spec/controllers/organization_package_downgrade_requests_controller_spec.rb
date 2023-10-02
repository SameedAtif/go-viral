require 'rails_helper'
require 'spec_helper'

RSpec.describe OrganizationPackageDowngradeRequestsController do
  describe '#create' do
    let(:client) {create(:client)}
    let(:organization) do
      org = create(:organization, :verified)
      org_detail = create(:organization_detail, :owner, organization: org, client: client)
      org_system_package = create(:system_package, gross_price: 1500, fee: 0.01)
      create(:organization_system_package, organization: org, system_package: org_system_package)
      org
    end
    let(:new_cheap_system_package) { create(:system_package, gross_price: 150, fee: 0.01) }
    let(:request_payload) {
      {
        organization_id: organization.id,
        organization_package_downgrade_request: {
          requested_package_id: new_cheap_system_package.id,
          reason: "I want to downgrade",
          status: "approved"
        }
      }
    }
    before do
      sign_in(client.user, scope: :user)
      session_params = {user_role: User::USER_ROLES[:client]}
      post 'create', params: request_payload, session: session_params
    end

    it 'will create request for a given client' do
      expect(organization.organization_package_downgrade_requests.count).to eq(1)
      update_keys = [
        :requested_package_id, :reason
      ].map { |k, _| k.to_sym}
      req = organization.organization_package_downgrade_requests.last
      update_keys.each do |key|
        expect(req.reload.send(key)).to eq(request_payload[:organization_package_downgrade_request][key])
      end
    end

    it "will not create with restricted param" do
      update_keys = [
        :status
      ].map { |k, _| k.to_sym}
      req = organization.organization_package_downgrade_requests.last
      update_keys.each do |key|
        expect(req.reload.send(key)).not_to eq(request_payload[:organization_package_downgrade_request][key])
      end
    end
  end

  describe '#update' do
    let(:client) {create(:client)}
    let(:reviewer) {create(:reviewer)}
    let(:organization) do
      org = create(:organization, :verified)
      org_detail = create(:organization_detail, :owner, organization: org, client: client)
      org_system_package = create(:system_package, gross_price: 1500, fee: 0.01)
      create(:organization_system_package, organization: org, system_package: org_system_package)
      org
    end
    let(:organization_package_downgrade_request) {create(:organization_package_downgrade_request, organization: organization)}
    let(:request_payload) {
      {
        id: organization_package_downgrade_request.id,
        organization_package_downgrade_request: {
          refundable_amount: 0,
          fee: 0,
          status: "approved"
        }
      }
    }
    context 'when user is signed in as client' do
      before do
        sign_in(client.user, scope: :user)
      end
      it 'will raise authorization error' do
        session_params = {user_role: User::USER_ROLES[:client]}
        expect do
          put 'update', params: request_payload, session: session_params
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when user is signed in as reviewer' do
      before do
        sign_in(reviewer.user, scope: :user)
      end
      it 'will update the request' do
        session_params = {user_role: User::USER_ROLES[:reviewer]}
        put 'update', params: request_payload, session: session_params
        update_keys = [
          :refundable_amount, :fee, :status
        ].map { |k, _| k.to_sym}
        update_keys.each do |key|
          expect(organization_package_downgrade_request.reload.send(key)).to eq(request_payload[:organization_package_downgrade_request][key])
        end
      end
    end
  end
end
