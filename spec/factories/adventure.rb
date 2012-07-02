# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :adventure do
    market 
    sold_out  false
    latitude  40.000
    longitude 40.000
    details "<li>Stuff here</li>"
    price     10.0
    duration  5.0
    sequence(:title) {|n| "title#{n}"} 
    image_url "http://a2.ak.lscdn.net/imgs/60702096-712b-4c13-8f98-87cf0fc51873/700_q60_.jpg"   
  end
end
