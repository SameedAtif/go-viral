require 'rails_helper'
require 'spec_helper'

RSpec.describe GigDeliverablesController do
  describe "POST create" do
    let(:client) do
      client = create(:client)
      org = create(:organization, :verified)
      org_detail = create(:organization_detail, :owner, organization: org, client: client)
      client
    end
    let(:influencer) { create(:influencer, :reviewed) }
    let(:gig) { create :gig, :reviewed, influencer: influencer }
    let(:gig_package) { create :gig_package, gig: gig }
    let(:system_gig_transaction) { create :system_gig_transaction, gig_package: gig_package, client: client }
    let(:creation_params) {
      {
        gig_client_id: system_gig_transaction.gig_clients.first.id,
        gig_deliverable: {
          title: "This is a sample title",
          description: "This is a sample title. This is a sample title."
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be created" do
        post 'create', params: creation_params
        expect(GigDeliverable.count).to eq(0)
      end
    end

    context "when user is signed_in" do
      context "when user is signed in as client" do
        before :each do
          sign_in(client.user, scope: :user)
        end
        it "will not create the project deliverable" do
          session_params = {user_role: User::USER_ROLES[:client]}
          expect do
            post 'create', params: creation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "when user is creator" do
        let(:session_params) {{user_role: User::USER_ROLES[:influencer]}}
        before :each do
          sign_in(influencer.user, scope: :user)
        end
        context "when creator is reviewed" do
          it "will create project deliverable" do
            post 'create', params: creation_params, session: session_params
            expect(GigDeliverable.count).to eq(1)
          end
        end
      end
    end
  end

  # Who can update?
  # - Creator who is reviewed
  # - Client who is the owner of the project
  describe "PUT/PATCH update" do
    let(:client) do
      client = create(:client)
      org = create(:organization, :verified)
      org_detail = create(:organization_detail, :owner, organization: org, client: client)
      client
    end
    let(:influencer) { create(:influencer, :reviewed) }
    let(:gig) { create :gig, :reviewed, influencer: influencer }
    let(:gig_package) { create :gig_package, gig: gig }
    let(:system_gig_transaction) { create :system_gig_transaction, gig_package: gig_package, client: client }
    let(:gig_deliverable) { create(:gig_deliverable, gig_client: system_gig_transaction.gig_clients.first)}
    let(:updation_params) {
      {
        id: gig_deliverable.id,
        gig_deliverable: {
          title: "This is a sample title",
          description: "This is a sample title. This is a sample title."
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be updated" do
        put 'update', params: updation_params
        update_keys = [
          :title, :description
        ].map { |k, _| k.to_sym}
        update_keys.each do |key|
          expect(gig_deliverable.reload.send(key)).not_to eq(updation_params[:gig_deliverable][key])
        end
      end
    end

    context "when user is signed_in" do
      context "when user is signed in as client" do
        before :each do
          sign_in(gig_deliverable.gig_client.client.user, scope: :user)
        end
        it "will throw pundit authorization errro" do
          session_params = {user_role: User::USER_ROLES[:client]}
          expect do
            put 'update', params: updation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
      context "when user is signed in as creator" do
        before :each do
          sign_in(gig_deliverable.gig_client.gig.influencer.user, scope: :user)
        end
        context "when valid status is passed" do
          it "will update creator allowed fields" do
            session_params = {user_role: User::USER_ROLES[:influencer]}
            put 'update', params: updation_params, session: session_params
            update_keys = [
              :title, :description
            ].map { |k, _| k.to_sym}
            update_keys.each do |key|
              expect(gig_deliverable.reload.send(key)).to eq(updation_params[:gig_deliverable][key])
            end
          end
        end
      end

      context "when user is not the owner" do
        let(:user) { create(:user, :client)}
        before :each do
          sign_in(user, scope: :user)
        end
        it "will not update the project" do
          session_params = {user_role: User::USER_ROLES[:influencer]}
          expect do
            put 'update', params: updation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end
end
