# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :adventure_date do
    date Date.today
  end
end
