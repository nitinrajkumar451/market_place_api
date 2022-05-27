FactoryBot.define do
    factory :product do
        title {"alpha@incubyte.co"}
        price {100}
        published {true}
        user_id {1}
    end
end