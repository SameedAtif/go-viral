require 'rails_helper'
require 'spec_helper'

RSpec.describe GigDisputesController do
  describe '#create' do
    context 'when user is signed_in' do
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

      let(:gig_dispute_params) {
        {
          gig_client_id: system_gig_transaction.gig_clients.first.id,
          gig_dispute: {
            detail: "This is a sample detail.",
          }
        }
      }
      context 'when user is client' do
        let(:session_params) { {user_role: User::USER_ROLES[:client]} }
        before do
          sign_in(client.user, scope: :user)
          post 'create', params: gig_dispute_params, session: session_params
        end
        it 'will create dispute for logged in client' do
          expect(GigDispute.count).to eq(1)
          expect(GigDispute.last.created_by).to eq(session_params[:user_role])
        end
      end

      context 'when user is influencer' do
        let(:session_params) { {user_role: User::USER_ROLES[:influencer]} }
        before do
          sign_in(influencer.user, scope: :user)
          post 'create', params: gig_dispute_params, session: session_params
        end
        it 'will create dispute for logged in client' do
          expect(GigDispute.count).to eq(1)
          expect(GigDispute.last.created_by).to eq(session_params[:user_role])
        end
      end
    end
  end

  describe '#update' do
    context 'when user is signed in' do
      context 'when user is the dispute creator' do
        let(:gig_dispute) { create(:gig_dispute, :created_by_client) }
        let(:gig_dispute_params) { {
          id: gig_dispute.id,
          gig_dispute: {
            detail: "New detail",
            status: "payment_approved",
            resolved_in_favor: "clients"
          }
        } }
        let(:session_params) { {user_role: User::USER_ROLES[:client]} }
        before do
          sign_in(gig_dispute.gig_client.client.user, scope: :user)
          put 'update', params: gig_dispute_params, session: session_params
        end
        it 'will only update user-allowed attributes' do
          expect(gig_dispute.reload.detail).to eq(gig_dispute_params[:gig_dispute][:detail])
          expect(gig_dispute.reload.status).not_to eq(gig_dispute_params[:gig_dispute][:status])
          expect(gig_dispute.reload.resolved_in_favor).not_to eq(gig_dispute_params[:gig_dispute][:resolved_in_favor])
        end
      end

      context 'when user is not the dispute creator' do
        let(:gig_dispute) { create(:gig_dispute, :created_by_client) }
        let(:gig_dispute_params) { {
          id: gig_dispute.id,
          gig_dispute: {
            detail: "New detail",
            status: "payment_approved",
            resolved_in_favor: "clients"
          }
        } }
        let(:session_params) { {user_role: User::USER_ROLES[:influencer]} }
        before do
          sign_in(gig_dispute.gig_client.gig.influencer.user, scope: :user)
        end
        it 'will not update user-allowed attributes' do
          expect do
            put 'update', params: gig_dispute_params, session: session_params
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
      context 'when user is a reviewer' do
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
        let(:gig_dispute) { create(:gig_dispute, :reviewer_assigned, :created_by_client, gig_client: system_gig_transaction.gig_clients.first) }

        let(:gig_dispute_params) { {
          id: gig_dispute.id,
          gig_dispute: {
            detail: "New detail",
            status: "payment_approved",
            resolved_in_favor: "client"
          }
        } }
        let(:session_params) { {user_role: User::USER_ROLES[:reviewer]} }
        before do
          sign_in(gig_dispute.reviewer.user, scope: :user)
          put 'update', params: gig_dispute_params, session: session_params
        end
        it 'will only update reviewer-allowed attributes' do
          expect(gig_dispute.reload.detail).not_to eq(gig_dispute_params[:gig_dispute][:detail])
          expect(gig_dispute.reload.status).to eq(gig_dispute_params[:gig_dispute][:status])
          expect(gig_dispute.reload.resolved_in_favor).to eq(gig_dispute_params[:gig_dispute][:resolved_in_favor])
        end
      end
    end
  end
end
