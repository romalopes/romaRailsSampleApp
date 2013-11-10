# FactoryGirl.define do
#   factory :user do
#     name     "Andersno Lopes"
#     email    "romalopes@yahoo.com.br"
#     password "foobar"
#     password_confirmation "foobar"
#   end
# end

# FactoryGirl.define do
#   factory :user do
#     sequence(:name)  { |n| "Person #{n}" }
#     sequence(:email) { |n| "person_#{n}@example.com"}
#     password "foobar"
#     password_confirmation "foobar"
#   end
#   factory :admin do
#       admin true
#   end
# end

FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  factory :micropost do
    content "Lorem ipsum"
    user
  end
end