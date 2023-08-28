require 'rails_helper'
require 'spec_helper'

RSpec.describe OrganizationsController do
  # Who can create? User
  describe "POST create" do
    let(:user) { create :user }
    let(:client_user) do
      user = create :user, :client
      create :client, user: user
      user
    end
    let(:creation_params) {
      {
        organization: {
          name: 'Sample 1',
          address_1: 'House no.1',
          address_2: 'Street 1, Avenue 1',
          city: 'City 1',
          country: 'Country 1',
          phone_number: '+111111111'
        }
      }
    }
    before :each do
      sign_in(user, scope: :user)
    end

    context "when user is not signed_in" do
      it "will not be created" do
        sign_out user
        post 'create', params: creation_params
        expect(Organization.count).to eq(0)
      end
    end

    context "when user is signed_in" do
      context "when client is present" do
        it "will not create client" do
          sign_out user
          sign_in client_user, scope: user
          post 'create', params: creation_params
          expect(Client.count).not_to eq(2)
        end
      end

      context "when client is absent" do
        it "will create client" do
          post 'create', params: creation_params
          expect(Client.count).to eq(1)
        end
      end

      it "will be created with required params" do
        post 'create', params: creation_params
        expect(Organization.count).to eq(1)
        expect(Organization.find_by(creation_params[:organization])).to be_present
      end

      it "will create organization detail with client" do
        post 'create', params: creation_params
        expect(OrganizationDetail.count).to eq(1)
        expect(
          OrganizationDetail.find_by(organization: Organization.last, client: Client.last, client_role: 'Owner')
        ).to be_present
      end

      it "will be created without reserved params" do
        post 'create', params: creation_params[:organization].merge(verified: true)
        expect(Organization.find_by(
          creation_params[:organization].merge(verified: true))
        ).not_to be_present
      end

      it "will not be created without required params" do
        creation_params[:organization].delete(:name)
        post 'create', params: {organization: {name: ""}}
        expect(Organization.find_by(name: "")).not_to be_present
      end
    end
  end

  # Who can update?
  # - Client who is the owner
  # - Reviewer can only update reviewed property
  describe "PUT/PATCH update" do
    let(:organization) do
      org_detail = create :organization_detail, :owner
      org_detail.organization
    end

    let(:updation_params) {
      {
        id: organization.id,
        organization: {
          name: 'Sample 1',
          address_1: 'House no.1',
          address_2: 'Street 1, Avenue 1',
          city: 'City 1',
          country: 'Country 1',
          phone_number: '+111111111'
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be updated" do
        put 'update', params: updation_params
        update_keys = updation_params[:organization].map { |k, _| k.to_sym}
        update_keys.each do |key|
          expect(organization.reload.send(key)).not_to eq(updation_params[:organization][key])
        end
      end
    end

    context "when user is signed_in" do
      context "when user is owner" do
        before :each do
          sign_in(organization.owner.user, scope: :user)
        end
        context "when user is signed in as client" do
          it "will update the organization" do
            session_params = {user_role: User::USER_ROLES[:client]}
            put 'update', params: updation_params, session: session_params
            update_keys = updation_params[:organization].map { |k, _| k.to_sym}
            update_keys.each do |key|
              expect(organization.reload.send(key)).to eq(updation_params[:organization][key])
            end
          end
        end
        context "when user is signed in as creator" do
          it "will not update the organization" do
            session_params = {user_role: User::USER_ROLES[:influencer]}
            expect do
              put 'update', params: updation_params, session: session_params
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end

      context "when user is not the owner" do
        let(:user) { create(:user, :client)}
        before :each do
          sign_in(user, scope: :user)
        end
        it "will not update the organization" do
          session_params = {user_role: User::USER_ROLES[:client]}
          expect do
            put 'update', params: updation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      xit "when user is of type reviewer" do
        post 'create', params: updation_params
        expect(Organization.count).to eq(1)
        expect(Organization.find_by(updation_params[:organization])).to be_present
      end
    end
  end
end
