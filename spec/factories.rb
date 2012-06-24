FactoryGirl.define :user do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    password "foobar"
    password_confirmation "foobar"
  end
end
