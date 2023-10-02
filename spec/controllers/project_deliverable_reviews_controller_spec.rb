require 'rails_helper'
require 'spec_helper'

RSpec.describe ProjectDeliverableReviewsController do
  describe "POST create" do
    let(:client_user) do
      user = create :user, :client
      client = create :client, user: user
      user
    end
    let(:project_deliverable) do
      organization = create :organization, :verified
      create :organization_detail, :owner, client: client_user.client, organization: organization
      project = create :project, :reviewed, :payment_verified, organization: organization
      milestone = create :project_milestone, project: project
      influencer = create :influencer, :reviewed
      project_influencer = create :project_influencer, project: project, influencer: influencer
      project_deliverable = create :project_deliverable, project_milestone: milestone, influencer: influencer
    end
    let(:creation_params) {
      {
        project_deliverable_id: project_deliverable.id,
        project_deliverable_review: {
          achieved_reach: 10001,
          achieved_conversion: 1001,
          remarks: "Faker::Quote.famous_last_words",
          rating: 3.5
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be created" do
        post 'create', params: creation_params
        expect(ProjectDeliverableReview.count).to eq(0)
      end
    end

    context "when user is signed_in" do
      before :each do
        sign_in(client_user, scope: :user)
      end
      context "when user is signed in as creator" do
        it "will not create the project deliverable review" do
          session_params = {user_role: User::USER_ROLES[:creator]}
          expect(ProjectDeliverableReview.count).to eq(0)
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
            expect(ProjectDeliverableReview.count).to eq(1)
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
    let(:client_user) do
      user = create :user, :client
      client = create :client, user: user
      user
    end
    let(:project_deliverable_review) do
      organization = create :organization, :verified
      create :organization_detail, :owner, client: client_user.client, organization: organization
      project = create :project, :reviewed, :payment_verified, organization: organization
      milestone = create :project_milestone, project: project
      influencer = create :influencer, :reviewed
      project_influencer = create :project_influencer, project: project, influencer: influencer
      project_deliverable = create :project_deliverable, project_milestone: milestone, influencer: influencer
      create :project_deliverable_review, project_deliverable: project_deliverable
    end
    let(:updation_params) {
      {
        id: project_deliverable_review.id,
        project_deliverable_review: {
          achieved_reach: 10001,
          achieved_conversion: 1001,
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
          :achieved_reach,
          :achieved_conversion,
          :remarks,
          :rating,
          :status
        ].map { |k, _| k.to_sym}
        update_keys.each do |key|
          expect(project_deliverable_review.reload.send(key)).not_to eq(updation_params[:project_deliverable_review][key])
        end
      end
    end

    context "when user is signed_in" do
      context "when user is signed in as creator" do
        before :each do
          sign_in(client_user, scope: :user)
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
          sign_in(project_deliverable_review.client.user, scope: :user)
        end
        it "will update creator allowed fields" do
          session_params = {user_role: User::USER_ROLES[:client]}
          put 'update', params: updation_params, session: session_params
          update_keys = [
            :achieved_reach,
            :achieved_conversion,
            :remarks,
            :rating,
            :status
          ].map { |k, _| k.to_sym}
          update_keys.each do |key|
            expect(project_deliverable_review.reload.send(key)).to eq(updation_params[:project_deliverable_review][key])
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
