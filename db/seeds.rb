# This file should contain all the record creation needed to seed the database with its default values.
basic_client_package = SystemPackage.create!(
  entity_name: SystemPackage::ENTITY_NAME_TYPES[:client],
  package_name: 'Basic',
  package_description: "Get a feel of the bazaar.",
  discount: 0,
  gross_price: 0,
  fee: 0
)

# Based on a package, a given table is restricted or update
# In basic client package, a organization can create 1 project with 2 influencers
# Meaning, there will be two system_package_resources for that organization.
# Note: resource_name is not the table name, but the functionality name.
# For example 'client can only have n number_of_projects in x package', it could be 'number_of_projects' and combined with resource_value ('1', '10')
# this functionality can become dynamic.
# Another case would be 'influencer can receive payment after 15 days'. resource_name: 'influencer_pay_in_days' and value could be '30'
# Another case would be 'influencer is pro'. resource_name: 'influencer_pro', value: 'true'
# The only thing the developer needs to ensure is that the datatype of the string and the functional .

SystemPackageResource.create!(
  system_package: basic_client_package,
  category: SystemPackageResource::CATEGORY_TYPES[:free],
  resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_projects],
  resource_value: SystemPackageResource::BASIC_RESOURCE_VALUE_MAP[:project],
  gross_price: 0,
  fee: 0,
  discount: 0
)
SystemPackageResource.create!(
  system_package: basic_client_package,
  category: SystemPackageResource::CATEGORY_TYPES[:free],
  resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_influencers],
  resource_value: SystemPackageResource::BASIC_RESOURCE_VALUE_MAP[:influencer],
  gross_price: 0,
  fee: 0,
  discount: 0
)

basic_influencer_package = SystemPackage.create!(
  entity_name: SystemPackage::ENTITY_NAME_TYPES[:influencer],
  package_name: 'Basic',
  package_description: "Get a feel of the bazaar.",
  discount: 0,
  gross_price: 0,
  fee: 0
)
SystemPackageResource.create!(
  system_package: basic_influencer_package,
  category: SystemPackageResource::CATEGORY_TYPES[:free],
  resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_gigs],
  resource_value: SystemPackageResource::BASIC_RESOURCE_VALUE_MAP[:gig],
  gross_price: 0,
  fee: 0,
  discount: 0
)
