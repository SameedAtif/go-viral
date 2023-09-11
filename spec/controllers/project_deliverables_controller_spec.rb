require 'rails_helper'
require 'spec_helper'

RSpec.describe ProjectDeliverablesController do
  describe "POST create" do
    let(:influencer_user) do
      user = create :user, :influencer
      influencer = create :influencer, user: user
      user
    end
    let(:project) do
      project = create :project, :reviewed, :payment_verified
      create :project_milestone, project: project
      create :project_influencer, project: project, influencer: influencer_user.influencer
      project
    end
    let(:creation_params) {
      {
        project_milestone_id: project.project_milestones.first.id,
        project_deliverable: {
          project_id: project.id,
          influencer_id: influencer_user.influencer.id,
          project_milestone_id: project.project_milestones.first.id,
          title: "This is a sample title",
          description: "This is a sample title. This is a sample title."
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be created" do
        post 'create', params: creation_params
        expect(ProjectDeliverable.count).to eq(0)
      end
    end

    context "when user is signed_in" do
      before :each do
        sign_in(influencer_user, scope: :user)
      end
      context "when user is signed in as client" do
        it "will not create the project deliverable" do
          session_params = {user_role: User::USER_ROLES[:client]}
          expect(ProjectDeliverable.count).to eq(0)
          expect do
            post 'create', params: creation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "when user is creator" do
        let(:session_params) {{user_role: User::USER_ROLES[:influencer]}}

        context "when creator is reviewed" do
          before(:each) do
            influencer_user.influencer.update(reviewed: true)
          end
          it "will create project deliverable" do
            post 'create', params: creation_params, session: session_params
            expect(ProjectDeliverable.count).to eq(1)
          end
        end

        context "when creator is not part of project" do
          it "will not create project deliverable" do
            expect do
              post 'create', params: creation_params, session: session_params
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end

      context "when creator is absent" do
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
    let(:influencer_user) do
      user = create :user, :influencer
      influencer = create :influencer, :reviewed, user: user
      user
    end
    let(:project_deliverable) do
      client = create :client, user: influencer_user
      organization = create :organization, :verified
      create :organization_detail, :owner, client: client, organization: organization
      project = create :project, organization: organization
      project_milestone = create :project_milestone, project: project
      create :project_deliverable, project_milestone: project_milestone
    end
    let(:updation_params) {
      {
        id: project_deliverable.id,
        project_deliverable: {
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
          expect(project_deliverable.reload.send(key)).not_to eq(updation_params[:project_deliverable][key])
        end
      end
    end

    context "when user is signed_in" do
      context "when user is signed in as client" do
        before :each do
          sign_in(project_deliverable.project_milestone.project.organization.owner.user, scope: :user)
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
          sign_in(project_deliverable.influencer.user, scope: :user)
        end
        context "when valid status is passed" do
          it "will update creator allowed fields" do
            session_params = {user_role: User::USER_ROLES[:influencer]}
            project_deliverable.influencer.update(reviewed: true)
            put 'update', params: updation_params, session: session_params
            update_keys = [
              :title, :description
            ].map { |k, _| k.to_sym}
            update_keys.each do |key|
              expect(project_deliverable.reload.send(key)).to eq(updation_params[:project_deliverable][key])
            end
          end
        end
        context "when invalid status is passed" do
          it "will raise pundit authorizatione error" do
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
