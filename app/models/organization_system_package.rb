class OrganizationSystemPackage < ApplicationRecord
  belongs_to :organization
  belongs_to :system_package

  has_many :organization_system_package_resources
  has_many :organization_system_package_transactions

  after_create :create_organization_system_package_resources, :create_organization_system_package_transaction

  def refund!
    # res = api call
    # if res.success?
    # find the last credit transaction associated to this record
    credit_transaction = organization_system_package_transactions.where(transaction_type: 'credit').last
    # duplicate it and set the transaction_type and token based on api-call
    debit_transaction = credit_transaction.dup
    debit_transaction.transaction_type = 'debit'
    debit_transaction.transaction_token = 'EFG'
    debit_transaction.save!
    # duplicate transaction resource record and associate it to new transaction record
    credit_transaction.organization_system_package_resource_transactions.each do |org_sys_pkg_res_trans|
      debit_resource_transaction = org_sys_pkg_res_trans.dup
      debit_resource_transaction.organization_system_package_transaction = debit_transaction.id
      debit_resource_transaction.save!
    end
    self.refunded = true
    organization.update(payment_plan: 'basic')
    salf.save!
    # set refunded: true
  end

  private

  def create_organization_system_package_resources
    system_package.system_package_resources.each do |resource|
      OrganizationSystemPackageResource.create!(
        organization_system_package: self,
        system_package_resource: resource
      )
    end
  end
end
