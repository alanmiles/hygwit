FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
    
    factory :superuser do
      admin true
      superuser true
    end
  end
  
  factory :nationality do
    #sequence(:nationality) { |n| "Nationality #{n}" }
    nationality "Qatari"
  end
  
  factory :currency do
    currency "Qatari Riyals"
    code "QAR"
  end
  
  factory :absence_type do
    sequence(:absence_code) { |n| "AB#{n}" }
  end
  
  factory :country do
    country :Qatar
    nationality
    currency
  end
  
  factory :country_absence do
    absence_code "SF"
    country
  end
end
