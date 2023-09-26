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
      let(:system_package) { create(:system_package, gross_price: 150, fee: 0.01) }
      let(:organization_system_package_resource_params) {
        {
          organization_id: organization.id,
          organization_system_package: {
            system_package_id: system_package.id
          }
        }
      }
      context 'when organization_system_package is not present' do
        before do
          sign_in(client.user, scope: :user)
          session_params = {user_role: User::USER_ROLES[:client]}
          post 'create', params: organization_system_package_resource_params, session: session_params
        end
        it 'will create system package with given params' do
          expect(OrganizationSystemPackage.count).to eq(1)
        end
      end

      context 'when there is an existing organization system_package' do
        context 'when incoming package is expensive than existing package' do
          let!(:existing_system_package) { create(:system_package, gross_price: 15, fee: 0.01) }
          let!(:existing_org_sys_pkg) { create(:organization_system_package, organization: organization, system_package: existing_system_package) }
          it 'will assign the new package as current_package' do
            sign_in(client.user, scope: :user)
            session_params = {user_role: User::USER_ROLES[:client]}
            post 'create', params: organization_system_package_resource_params, session: session_params
            expect(OrganizationSystemPackage.count).to eq(2)
            expect(organization.organization_system_packages.count).to eq(2)
            expect(organization.current_package.id).to eq(system_package.id)
          end
        end

        context 'when incoming package is cheaper than existing package' do
          let!(:existing_system_package) { create(:system_package, gross_price: 1500, fee: 0.01) }
          context 'when downgrade request is absent' do
            let!(:existing_org_sys_pkg) { create(:organization_system_package, organization: organization, system_package: existing_system_package) }
            it 'will raise authorization error' do
              sign_in(client.user, scope: :user)
              session_params = {user_role: User::USER_ROLES[:client]}
              expect do
                post 'create', params: organization_system_package_resource_params, session: session_params
              end.to raise_error(Pundit::NotAuthorizedError)
            end
          end

          context 'when downgrade request is present and approved' do
            let!(:approved_downgrade_request) { create(:organization_package_downgrade_request,
              status: ::OrganizationPackageDowngradeRequest::STATUS_TYPES_MAP[:approved],
              current_package: existing_system_package, requested_package: system_package, organization: organization)}
            it 'will assign the new package as current_package' do
              sign_in(client.user, scope: :user)
              session_params = {user_role: User::USER_ROLES[:client]}
              new_organization_system_package_resource_params = {
                  organization_id: organization.id,
                  organization_system_package: {
                    system_package_id: existing_system_package.id
                  }
                }
              post 'create', params: new_organization_system_package_resource_params, session: session_params
              post 'create', params: organization_system_package_resource_params, session: session_params
              expect(OrganizationSystemPackage.count).to eq(2)
              expect(organization.organization_system_packages.count).to eq(2)
              expect(organization.current_package.id).to eq(system_package.id)
            end
          end
        end
      end
    end
  end
end
