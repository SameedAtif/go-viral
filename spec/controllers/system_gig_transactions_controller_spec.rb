require 'rails_helper'
require 'spec_helper'

RSpec.describe SystemGigTransactionsController do
  describe '#create' do
    context 'when user is signed in' do
      context 'when user is client' do
        let(:client) do
          client = create(:client)
          org = create(:organization, :verified)
          org_detail = create(:organization_detail, :owner, organization: org, client: client)
          client
        end
        let(:influencer) { create(:influencer, :reviewed) }
        let(:gig) { create :gig, :reviewed, influencer: influencer }
        let(:gig_package) { create :gig_package, gig: gig }
        let(:system_gig_transaction) {
          {
            gig_package_id: gig_package.id
          }
        }
        let(:session_params) { {user_role: User::USER_ROLES[:client]} }
        before do
          sign_in(client.user, scope: :user)
          post 'create', params: system_gig_transaction, session: session_params
        end
        it 'will create the system project transaction for each applicant' do
          expect(SystemGigTransaction.count).to eq(1)
        end
      end
    end
  end
end
