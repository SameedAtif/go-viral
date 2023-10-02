require 'rails_helper'
require 'spec_helper'

RSpec.describe SystemPackagesController do
  describe '#create' do
    context 'when user is signed_in' do
      let(:system_package_params) {
        {
          system_package: {
            payment_plan: 'year',
            system_package_resources_attributes: [
              {
                resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_projects],
                resource_value: '10'
              }
            ]
          }
        }
      }
      before do
        sign_in(create(:user), scope: :user)
        session_params = {user_role: User::USER_ROLES[:client]}
        post 'create', params: system_package_params, session: session_params
      end
      it 'will create system package with given params' do
        expect(SystemPackage.count).to eq(1)
      end
    end
  end
end
