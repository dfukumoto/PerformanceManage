FactoryGirl.define do
  factory :user do
        name    Faker::Name.name
       email    Faker::Internet.email
    password              "foobar"
    password_confirmation "foobar"


    factory :admin do
      authority 1
      after(:create) {|admin|
        create(:performance, user: admin, project: create(:project))
      }
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
    group       1
    order       "ExampleInc"
    project_code  "EXAMPLECODE"
  end
end
