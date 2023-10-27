require 'rails_helper'
require 'spec_helper'

RSpec.describe SystemProjectTransactionsController do
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
        let(:project) { create :project, :reviewed, :payment_verified, organization: client.organization, budget: 2200 }
        let(:project_application) { create :project_application, influencer: influencer, project: project, status: 'approved', budget: 2000 }
        let(:system_project_transaction) {
          {
            system_project_transaction: {
              project_applications: [
                {
                  id: project_application.id
                }
              ]
            }
          }
        }
        let(:session_params) { {user_role: User::USER_ROLES[:client]} }
        before do
          sign_in(client.user, scope: :user)
          post 'create', params: system_project_transaction, session: session_params
        end
        it 'will create the system project transaction for each applicant' do
          expect(SystemProjectTransaction.count).to eq(1)
        end
      end
    end
  end
end
