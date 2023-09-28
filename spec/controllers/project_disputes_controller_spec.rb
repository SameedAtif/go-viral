require 'rails_helper'
require 'spec_helper'

RSpec.describe ProjectDisputesController do
  describe '#create' do
    context 'when user is signed_in' do
      let(:client) do
        client = create(:client)
        org = create(:organization, :verified)
        org_detail = create(:organization_detail, :owner, organization: org, client: client)
        client
      end
      let(:influencer) { create(:influencer, :reviewed) }
      let(:project) do
        project = create :project, :reviewed, :payment_verified, organization: client.organization
        project_influencer = create(:project_influencer, project: project, influencer: influencer)
        project
      end
      let(:project_dispute_params) {
        {
          project_id: project.id,
          project_dispute: {
            detail: "This is a sample detail.",
            influencer_id: influencer.id
          }
        }
      }
      context 'when user is client' do
        let(:session_params) { {user_role: User::USER_ROLES[:client]} }
        before do
          sign_in(client.user, scope: :user)
          post 'create', params: project_dispute_params, session: session_params
        end
        it 'will create dispute for logged in client' do
          expect(ProjectDispute.count).to eq(1)
          expect(ProjectDispute.last.created_by).to eq(session_params[:user_role])
          expect(ProjectDispute.last.client.id).to eq(client.id)
          expect(ProjectDispute.last.influencer.id).to eq(project_dispute_params[:project_dispute][:influencer_id])
        end
      end

      context 'when user is influencer' do
        let(:session_params) { {user_role: User::USER_ROLES[:influencer]} }
        before do
          sign_in(influencer.user, scope: :user)
          post 'create', params: project_dispute_params, session: session_params
        end
        it 'will create dispute for logged in client' do
          expect(ProjectDispute.count).to eq(1)
          expect(ProjectDispute.last.created_by).to eq(session_params[:user_role])
          expect(ProjectDispute.last.client.id).to eq(client.id)
          expect(ProjectDispute.last.influencer.id).to eq(influencer.id)
        end
      end
    end
  end

  describe '#update' do
    context 'when user is signed in' do
      context 'when user is the dispute creator' do
        let(:project_dispute) { create(:project_dispute, :created_by_client) }
        let(:project_dispute_params) { {
          id: project_dispute.id,
          project_dispute: {
            detail: "New detail",
            status: "payment_approved",
            resolved_in_favor: "clients"
          }
        } }
        let(:session_params) { {user_role: User::USER_ROLES[:client]} }
        before do
          sign_in(project_dispute.client.user, scope: :user)
          put 'update', params: project_dispute_params, session: session_params
        end
        it 'will only update user-allowed attributes' do
          expect(project_dispute.reload.detail).to eq(project_dispute_params[:project_dispute][:detail])
          expect(project_dispute.reload.status).not_to eq(project_dispute_params[:project_dispute][:status])
          expect(project_dispute.reload.resolved_in_favor).not_to eq(project_dispute_params[:project_dispute][:resolved_in_favor])
        end
      end

      context 'when user is not the dispute creator' do
        let(:project_dispute) { create(:project_dispute, :created_by_client) }
        let(:project_dispute_params) { {
          id: project_dispute.id,
          project_dispute: {
            detail: "New detail",
            status: "payment_approved",
            resolved_in_favor: "clients"
          }
        } }
        let(:session_params) { {user_role: User::USER_ROLES[:influencer]} }
        before do
          sign_in(project_dispute.influencer.user, scope: :user)
        end
        it 'will not update user-allowed attributes' do
          expect do
            put 'update', params: project_dispute_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
      context 'when user is a reviewer' do
        let(:project_dispute) { create(:project_dispute, :reviewer_assigned, :created_by_client) }
        let(:project_dispute_params) { {
          id: project_dispute.id,
          project_dispute: {
            detail: "New detail",
            status: "payment_approved",
            resolved_in_favor: "client"
          }
        } }
        let(:session_params) { {user_role: User::USER_ROLES[:reviewer]} }
        before do
          sign_in(project_dispute.reviewer.user, scope: :user)
          put 'update', params: project_dispute_params, session: session_params
        end
        it 'will only update reviewer-allowed attributes' do
          expect(project_dispute.reload.detail).not_to eq(project_dispute_params[:project_dispute][:detail])
          expect(project_dispute.reload.status).to eq(project_dispute_params[:project_dispute][:status])
          expect(project_dispute.reload.resolved_in_favor).to eq(project_dispute_params[:project_dispute][:resolved_in_favor])
        end
      end
    end
  end
end
