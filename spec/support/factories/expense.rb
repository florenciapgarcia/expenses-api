FactoryBot.define do
  factory :expense do
    title { "Groceries" }
    amount_in_cents { 100 }
    date { Date.current }
  end
end
