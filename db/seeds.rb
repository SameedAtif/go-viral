require 'factory_bot_rails'

basic_client_package = SystemPackage.find_or_create_by!(
  entity_name: SystemPackage::ENTITY_NAME_TYPES[:client],
  package_name: 'Basic',
  package_description: "Get a feel of the bazaar.",
  discount: 0,
  gross_price: 0,
  fee: 0
)
SystemPackageResource.find_or_create_by!(
  system_package: basic_client_package,
  category: SystemPackageResource::CATEGORY_TYPES[:free],
  resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_projects],
  resource_value: SystemPackageResource::BASIC_RESOURCE_VALUE_MAP[:project],
  gross_price: 0,
  fee: 0,
  discount: 0
)
SystemPackageResource.find_or_create_by!(
  system_package: basic_client_package,
  category: SystemPackageResource::CATEGORY_TYPES[:free],
  resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_influencers],
  resource_value: SystemPackageResource::BASIC_RESOURCE_VALUE_MAP[:influencer],
  gross_price: 0,
  fee: 0,
  discount: 0
)

basic_influencer_package = SystemPackage.find_or_create_by!(
  entity_name: SystemPackage::ENTITY_NAME_TYPES[:influencer],
  package_name: 'Basic',
  package_description: "Get a feel of the bazaar.",
  discount: 0,
  gross_price: 0,
  fee: 0
)
SystemPackageResource.find_or_create_by!(
  system_package: basic_influencer_package,
  category: SystemPackageResource::CATEGORY_TYPES[:free],
  resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_gigs],
  resource_value: SystemPackageResource::BASIC_RESOURCE_VALUE_MAP[:gig],
  gross_price: 0,
  fee: 0,
  discount: 0
)

Platform.create!(
  name: "Youtube",
  url: "https://www.youtube.com/"
)
Platform.create!(
  name: "Facebook",
  url: "https://www.facebook.com/"
)
Platform.create!(
  name: "Instagram",
  url: "https://www.instagram.com/"
)
Platform.create!(
  name: "LinkedIn",
  url: "https://www.linkedin.com/"
)

reviewers = []
influencers = []
clients = []
# create reviewer
(0..10).each do |i|
  user = User.create!(
    first_name: "John",
    last_name: "Reviewer #{i}",
    phone_number: "+92#{Random.new.rand(1_000_000..10_000_000-1)}",
    email: "reviewer#{i}@example.com",
    user_roles: [User::USER_ROLES[:reviewer]],
    password: "password",
    password_confirmation: "password",
    confirmed_at: DateTime.current
  )
  reviewer = Reviewer.find_or_create_by!(user: user)
  reviewers << reviewer
end
# create influencer
(0..10).each do |i|
  user = User.create!(
    first_name: "John",
    last_name: "Influencer #{i}",
    phone_number: "+92#{Random.new.rand(1_000_000..10_000_000-1)}",
    email: "influencer#{i}@example.com",
    user_roles: [User::USER_ROLES[:influencer]],
    password: "password",
    password_confirmation: "password",
    confirmed_at: DateTime.current
  )
  influencer = FactoryBot.create(:influencer, :reviewed, user: user)
  # create influencer gig
  3.times do
    gig = FactoryBot.create :gig, :reviewed, influencer: influencer
    2.times { FactoryBot.create(:gig_package, gig: gig) }
  end
  influencers << influencer
end
# create client
(0..10).each do |i|
  user = User.create!(
    first_name: "John",
    last_name: "Client #{i}",
    phone_number: "+92#{Random.new.rand(1_000_000..10_000_000-1)}",
    email: "client#{i}@example.com",
    user_roles: [User::USER_ROLES[:client]],
    password: "password",
    password_confirmation: "password",
    confirmed_at: DateTime.current
  )
  client = FactoryBot.create :client, user: user
  organization = FactoryBot.create :organization, :verified
  FactoryBot.create :organization_detail, :owner, client: client, organization: organization
  1.times do
    project = FactoryBot.create :project, :reviewed, :payment_verified, organization: organization, status: Project::STATUSES_MAP[:approved]
    2.times { FactoryBot.create :project_milestone, project: project }
  end
end

