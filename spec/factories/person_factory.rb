FactoryGirl.define do
  factory :person do
    sequence(:trogdir_id) { |n| "abcdefg#{n}" }
    sequence(:biola_id) { |n| n }
    first_name { Faker::Name.first_name }
    preferred_name { first_name }
    middle_name { Faker::Name.first_name}
    last_name { Faker::Name.last_name }
    gender { [:male, :female].sample }
    birth_date { 20.years.ago }
    affiliations { [[:student, :employee, :alumnus, :trustee].sample] }
    biola_email "jane.doe@fakebiola.edu"
    biola_personal_email "jdoe@gmail.com"
    personal_email { "#{first_name}.#{last_name}@example.com" }
    previous_last_name { [Faker::Name.last_name] }
    personal_phone { Faker::PhoneNumber.cell_phone }
    personal_website { "http://#{Faker::Internet.domain_name}"}
    biola_photo_url { Faker::Internet.url('example.com') }

    trait :alumnus do
      affiliations [:alumnus]
      degree_received "BS in Computer Science"
      graduation_year "2002"
    end

    trait :employee do
      affiliations [:employee]
      department { Faker::Commerce.department }
      given_title { Faker::Name.title }
      # employee_type { ["Faculty", "Staff", "Student Worker"].sample }
      employee_phone { Faker::PhoneNumber.extension }
      biola_title { Faker::Name.title }
      custom_titles { [Faker::Name.title, Faker::Name.title] }
      office_location { Faker::Address.street_name }
      job_functions { [Faker::Company.catch_phrase] }
    end

    trait :student do
      affiliations [:student]
      majors { [["math", "english"].sample] }
      minors { [["history","biology"].sample] }
      level { ["undergrad", "grad", "doctoral", "TESOL"].sample }
      degree { ["Computer Science", "Biology", "Math"].sample }
      college { ["CSICS", "CSOB","Rosemead"].sample }
      student_department { Faker::Commerce.department }
    end
  end
end