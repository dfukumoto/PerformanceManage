FactoryGirl.define do
  factory :user do
    password              "foobar"
    password_confirmation "foobar"

    factory :admin do
      name    Faker::Name.name
      email    Faker::Internet.email
      authority 1
      after(:create) {|user|
        create(:performance, user: user, project: create(:project))
      }
    end

    factory :staff do
      name    Faker::Name.name
      email    Faker::Internet.email
      authority 2
      after(:create) {|user|
        create(:performance, user: user, project: create(:project))
      }
    end
    factory :partner do
      name    Faker::Name.name
      email    Faker::Internet.email
      authority 3
      after(:create) {|user|
        create(:performance, user: user, project: create(:project))
      }
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
