FactoryGirl.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Doe' }
    username { 'johnd' }
    biola_id { '12345678' }
    title { 'Cat Supervisor' }
    email { 'john.doe@biola.edu' }
    photo_url { '' }
    department { 'Repo' }

    affiliations { [] }
    entitlements { [] }
  end
end