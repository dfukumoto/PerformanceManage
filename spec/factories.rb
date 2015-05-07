FactoryGirl.define do
  factory :user do
        name    Faker::Name.name
       email    Faker::Internet.email
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

  factory :performance do
    project_id    1
    user_id       1
    start_time    "2015/05/07 11:00:00"
    end_time      "2015/05/07 17:00:00"
    content       "ExamplePerformance"
  end

  factory :project do
    name        "ExampleProject"
    start_date  "2015/04/01"
    end_date    "2015/09/01"
    group       1
    order       "ExampleInc"
    project_code  "EXAMPLECODE"
  end
end
