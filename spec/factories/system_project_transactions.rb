FactoryBot.define do
  factory :system_project_transaction do
    client
    project
    project_application
    gross_price { 100 }
    fee { 0.00 }
    transaction_token { 'ANBC' }
    transaction_type { 'credit' }
  end
end
