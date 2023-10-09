FactoryBot.define do
  factory :gig_client do
    gig
    client
    gig_package
    system_gig_transaction
  end
end
