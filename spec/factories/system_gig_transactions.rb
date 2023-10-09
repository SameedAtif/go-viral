FactoryBot.define do
  factory :system_gig_transaction do
    gig_package
    client
    gross_price { 100 }
    fee { 0.00 }
    transaction_token { 'ANBC' }
    transaction_type { 'credit' }
  end
end
