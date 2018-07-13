FactoryBot.define do
  factory :user do
    username { Faker::LordOfTheRings.character }
    password { Faker::Name.first_name  }
  end
end
