FactoryBot.define do
  factory :gig_dispute do
    gig_client
    status { 'pending_review' }
    detail { Faker::Quote.famous_last_words }
    trait :reviewer_assigned do
      reviewer
      status { 'review_in_progress' }
    end
    trait :created_by_client do
      created_by { 'client' }
    end
    trait :created_by_influencer do
      created_by { 'influencer' }
    end
    trait :resolved_for_client do
      status { 'payment_approved' }
      resolved_in_favor { 'client' }
      resolved_at { DateTime.current }
    end
    trait :resolved_for_influencer do
      status { 'payment_approved' }
      resolved_in_favor { 'influencer' }
      resolved_at { DateTime.current }
    end
  end
end
