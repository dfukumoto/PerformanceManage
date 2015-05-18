FactoryGirl.define do
  factory :user do
    password              "foobar"
    password_confirmation "foobar"
    name    { Faker::Name.name }
    email   { Faker::Internet.email }
    after(:create) do |user|
      create(:performance, user: user, project: create(:project))
    end

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

  factory :performance do
    project
    user
    start_time    "2015/05/07 11:00:00"
    end_time      "2015/05/07 17:00:00"
    content       Faker::Lorem.sentence
  end

  factory :project do
    name        "ExampleProject"
    start_date  "2015/04/01"
    end_date    "2015/09/01"
    group_id       1
    order       "ExampleInc"
    project_code  "EXAMPLECODE"
  end
end
