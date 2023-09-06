require 'rails_helper'
require 'spec_helper'

RSpec.describe ProjectApplicationsController do
  # Who can create? Creator
  describe "GET new" do
    let(:influencer_user) do
      user = create :user, :influencer
      influencer = create :influencer, user: user
      user
    end
    let(:project) { create :project, :reviewed, :payment_verified }
    let(:creation_params) {
      {
        project_id: project.id
      }
    }

    context "when user is signed_in" do
      before :each do
        sign_in(influencer_user, scope: :user)
      end
      context "when user is signed in as client" do
        it "will not create the project application" do
          session_params = {user_role: User::USER_ROLES[:client]}
          expect do
            get 'new', params: creation_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "when user is creator" do
        let(:session_params) {{user_role: User::USER_ROLES[:influencer]}}

        context "when user is not verified" do
          it "will not create project application" do
            expect do
              get 'new', params: creation_params, session: session_params
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
        context "when user is reviewed" do
          it "will create project application" do
            influencer_user.influencer.update(reviewed: true)
            expect do
              get 'new', params: creation_params, session: session_params
            end.not_to raise_error
          end
        end
      end

      context "when client is absent" do
        it "will not create project" do
          expect do
            get 'new', params: creation_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end

  describe "POST create" do
    let(:influencer_user) do
      user = create :user, :influencer
      influencer = create :influencer, user: user
      user
    end
    let(:project) { create :project, :reviewed, :payment_verified }
    let(:creation_params) {
      {
        project_id: project.id,
        project_application: {
          project_id: project.id,
          influencer_id: influencer_user.influencer.id,
          title: "This is a sample title",
          description: "This is a sample title. This is a sample title.",
          budge: 100.10,
          delivery_date: 15.days.from_now
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be created" do
        post 'create', params: creation_params
        expect(ProjectApplication.count).to eq(0)
      end
    end

    context "when user is signed_in" do
      before :each do
        sign_in(influencer_user, scope: :user)
      end
      context "when user is signed in as client" do
        it "will not create the project application" do
          session_params = {user_role: User::USER_ROLES[:client]}
          expect(ProjectApplication.count).to eq(0)
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
          it "will create project application" do
            post 'create', params: creation_params, session: session_params
            expect(ProjectApplication.count).to eq(1)
          end

          it "will not create with restricted params and value" do
            creation_params[:project_application].merge!(status: "approved")
            post 'create', params: creation_params, session: session_params
            expect(ProjectApplication.last.status).not_to eq("approved")
          end
        end

        context "when creator is not reviewed" do
          it "will create project application" do
            expect do
              post 'create', params: creation_params, session: session_params
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end

      context "when creator is absent" do
        it "will not create project application" do
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
    let(:project_application) do
      client = create :client, user: influencer_user
      organization = create :organization, :verified
      create :organization_detail, :owner, client: client, organization: organization
      project = create :project, organization: organization
      create :project_application, project: project, influencer: influencer_user.influencer
    end
    let(:updation_params) {
      {
        id: project_application.id,
        project_application: {
          title: "This is a sample title",
          description: "This is a sample title. This is a sample title.",
          budge: 100.10,
          status: "approved",
          delivery_date: 16.days.from_now
        }
      }
    }

    context "when user is not signed_in" do
      it "will not be updated" do
        put 'update', params: updation_params
        update_keys = [
          :title, :description, :budget, :delivery_date
        ].map { |k, _| k.to_sym}
        update_keys.each do |key|
          expect(project_application.reload.send(key)).not_to eq(updation_params[:project_application][key])
        end
      end
    end

    context "when user is signed_in" do
      context "when user is signed in as client" do
        before :each do
          sign_in(project_application.project.organization.owner.user, scope: :user)
        end
        it "will update client allowed fields" do
          session_params = {user_role: User::USER_ROLES[:client]}
          put 'update', params: updation_params, session: session_params
          update_keys = [
            :status
          ].map { |k, _| k.to_sym}
          update_keys.each do |key|
            expect(project_application.reload.send(key)).to eq(updation_params[:project_application][key])
          end
        end
      end
      context "when user is signed in as creator" do
        before :each do
          sign_in(project_application.influencer.user, scope: :user)
        end
        context "when valid status is passed" do
          it "will update creator allowed fields" do
            session_params = {user_role: User::USER_ROLES[:influencer]}
            updation_params[:project_application][:status] = 'ready_for_review'
            put 'update', params: updation_params, session: session_params
            update_keys = [
              :title, :description
            ].map { |k, _| k.to_sym}
            update_keys.each do |key|
              expect(project_application.reload.send(key)).to eq(updation_params[:project_application][key])
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

  # describe "GET edit" do
  #   let(:influencer_user) do
  #     user = create :user, :influencer
  #     influencer = create :influencer, :reviewed, user: user
  #     user
  #   end
  #   let(:project_application) do
  #     client = create :client, user: influencer_user
  #     organization = create :organization, :verified
  #     create :organization_detail, :owner, client: client, organization: organization
  #     project = create :project, organization: organization
  #     create :project_application, project: project, influencer: influencer_user.influencer
  #   end
  #   let(:updation_params) {
  #     {
  #       id: project_application.id
  #     }
  #   }

  #   context "when user is signed_in" do
  #     context "when user is signed in as client" do
  #       before :each do
  #         sign_in(project_application.project.organization.owner.user, scope: :user)
  #       end
  #       it "will not raise an error" do
  #         session_params = {user_role: User::USER_ROLES[:influencer]}
  #         expect do
  #           get 'edit', params: updation_params, session: session_params
  #         end.to raise_error(Pundit::NotAuthorizedError)
  #       end
  #     end
  #     context "when user is signed in as creator" do
  #       before :each do
  #         sign_in(project_application.influencer.user, scope: :user)
  #       end
  #       it "will not raise an error" do
  #         session_params = {user_role: User::USER_ROLES[:client]}
  #         expect do
  #           get 'edit', params: updation_params, session: session_params
  #         end.not_to raise_error
  #       end
  #     end
  #   end
  # end
end
