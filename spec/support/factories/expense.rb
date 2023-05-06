FactoryBot.define do
  factory :expense do
    title { "Test" }
    amount_in_cents { 1000 }
    date { Date.current }
    user { association :user }
  end

  trait :invalid_amount do
    amount_in_cents { "invalid" }
  end

end
