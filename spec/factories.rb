FactoryGirl.define do
  factory :user do
        name    "Example User"
       email    "user@example.com"
    password              "foobar"
    password_confirmation "foobar"

    factory :admin do
      authority 1
    end

    factory :staff do
      authority 2
    end
    factory :partner do
      authority 3
    end
  end
end
