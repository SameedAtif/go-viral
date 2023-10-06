require 'rails_helper'
require 'spec_helper'

RSpec.describe GigDeliverableReviewsController do
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
    let(:gig_client) { create(:gig_client, gig: gig, client: client, gig_package: gig_package, system_gig_transaction: system_gig_transaction)}
    let(:gig_deliverable) { create(:gig_deliverable, gig_client: gig_client)}

    let(:creation_params) {
      {
        gig_deliverable_id: gig_deliverable.id,
        gig_deliverable_review: {
          remarks: "Faker::Quote.famous_last_words",
          rating: 3.5
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be created" do
        post 'create', params: creation_params
        expect(GigDeliverableReview.count).to eq(0)
      end
    end

    context "when user is signed_in" do
      before :each do
        sign_in(client.user, scope: :user)
      end
      context "when user is signed in as creator" do
        it "will not create the project deliverable review" do
          session_params = {user_role: User::USER_ROLES[:influencer]}
          expect(GigDeliverableReview.count).to eq(0)
          expect do
            post 'create', params: creation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "when user is client" do
        let(:session_params) {{user_role: User::USER_ROLES[:client]}}

        context "when client is owner" do
          it "will create project deliverable" do
            post 'create', params: creation_params, session: session_params
            expect(GigDeliverableReview.count).to eq(1)
          end
        end
      end

      context "when client is absent" do
        it "will not create project deliverable" do
          expect do
            post 'create', params: creation_params
          end.to raise_error(Pundit::NotAuthorizedError)
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
    let(:gig_client) { create(:gig_client, gig: gig, client: client, gig_package: gig_package, system_gig_transaction: system_gig_transaction)}
    let(:gig_deliverable) { create(:gig_deliverable, gig_client: gig_client)}
    let(:gig_deliverable_review) { create(:gig_deliverable_review, gig_client: gig_client, client: client, gig_deliverable: gig_deliverable) }
    let(:updation_params) {
      {
        id: gig_deliverable_review.id,
        gig_deliverable_review: {
          remarks: "Faker::Quote.famous_last_words",
          rating: 3.5,
          status: "approved"
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be updated" do
        put 'update', params: updation_params
        update_keys = [
          :remarks,
          :rating,
          :status
        ].map { |k, _| k.to_sym}
        update_keys.each do |key|
          expect(gig_deliverable_review.reload.send(key)).not_to eq(updation_params[:gig_deliverable_review][key])
        end
      end
    end

    context "when user is signed_in" do
      context "when user is signed in as creator" do
        before :each do
          sign_in(client.user, scope: :user)
        end
        it "will throw pundit authorization errro" do
          session_params = {user_role: User::USER_ROLES[:influencer]}
          expect do
            put 'update', params: updation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
      context "when user is signed in as client" do
        before :each do
          sign_in(gig_deliverable_review.client.user, scope: :user)
        end
        it "will update creator allowed fields" do
          session_params = {user_role: User::USER_ROLES[:client]}
          put 'update', params: updation_params, session: session_params
          update_keys = [
            :remarks,
            :rating,
            :status
          ].map { |k, _| k.to_sym}
          update_keys.each do |key|
            expect(gig_deliverable_review.reload.send(key)).to eq(updation_params[:gig_deliverable_review][key])
          end
        end
      end

      context "when user is not the owner" do
        let(:user) { create(:user, :client)}
        before :each do
          sign_in(user, scope: :user)
        end
        it "will not update the project" do
          session_params = {user_role: User::USER_ROLES[:client]}
          expect do
            put 'update', params: updation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end
end
