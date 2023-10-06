require 'rails_helper'
require 'spec_helper'

RSpec.describe GigClientsController do
  describe '#update' do
    context 'when user is signed in' do
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
      context 'when user is client' do
        let(:session_params) { {user_role: User::USER_ROLES[:client]} }
        context 'when valid status is passed' do
          let(:gig_client_payload) {
            {
              id: gig_client.id,
              gig_client: {
                status: GigClient::STATUSES_MAP[:request_rolled_back]
              }
            }
          }
          before do
            sign_in(client.user, scope: :user)
            put 'update', params: gig_client_payload, session: session_params
          end
          it 'will create the system project transaction for each applicant' do
            expect(gig_client.reload.status).to eq(GigClient::STATUSES_MAP[:request_rolled_back])
          end
        end

        context 'when invalid status is passed' do
          let(:gig_client_payload) {
            {
              id: gig_client.id,
              gig_client: {
                status: GigClient::STATUSES_MAP[:accepted]
              }
            }
          }
          before do
            sign_in(client.user, scope: :user)
          end
          it 'will raise error' do
            expect do
              put 'update', params: gig_client_payload, session: session_params
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end
      context 'when user is influencer' do
        let(:session_params) { {user_role: User::USER_ROLES[:influencer]} }
        context 'when valid status is passed' do
          let(:gig_client_payload) {
            {
              id: gig_client.id,
              gig_client: {
                status: GigClient::STATUSES_MAP[:accepted]
              }
            }
          }
          before do
            sign_in(influencer.user, scope: :user)
            put 'update', params: gig_client_payload, session: session_params
          end
          it 'will create the system project transaction for each applicant' do
            expect(gig_client.reload.status).to eq(GigClient::STATUSES_MAP[:accepted])
          end
        end

        context 'when invalid status is passed' do
          let(:gig_client_payload) {
            {
              id: gig_client.id,
              gig_client: {
                status: GigClient::STATUSES_MAP[:request_rolled_back]
              }
            }
          }
          before do
            sign_in(influencer.user, scope: :user)
          end
          it 'will raise error' do
            expect do
              put 'update', params: gig_client_payload, session: session_params
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end
    end
  end
end
