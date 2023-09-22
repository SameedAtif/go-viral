require 'rails_helper'
require 'spec_helper'

RSpec.describe OrganizationSystemPackagesController do
  describe '#create' do
    context 'when organization_client is signed_in' do
      let(:client) {create(:client)}
      let(:organization) do
        org = create(:organization)
        org_detail = create(:organization_detail, :owner, organization: org, client: client)
        org
      end
      let(:system_package) { create(:system_package) }
      let(:organization_system_package_resource_params) {
        {
          organization_id: organization.id,
          organization_system_package: {
            system_package_id: system_package.id
          }
        }
      }
      before do
        sign_in(client.user, scope: :user)
        session_params = {user_role: User::USER_ROLES[:client]}
        post 'create', params: organization_system_package_resource_params, session: session_params
      end
      context 'when organization_system_package is not present' do
        it 'will create system package with given params' do
          expect(OrganizationSystemPackage.count).to eq(1)
        end
      end

      context 'when there is an existing organization system_package' do
        it 'will assign the new package as current_package' do
          new_system_package = create(:system_package)
          new_org_sys_pkg = create(:organization_system_package, organization: organization, system_package: new_system_package)
          expect(OrganizationSystemPackage.count).to eq(2)
          expect(organization.organization_system_packages.count).to eq(2)
          expect(organization.current_package.id).to eq(new_org_sys_pkg.id)
        end
      end
    end
  end
end
