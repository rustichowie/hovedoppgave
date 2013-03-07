FactoryGirl.define do
  factory :workhour do
    user_id 23
    count 5 
    comment ""
  end
  factory :workhours do
  sequence(:user_id) {|n| n}
    count 5 
    comment ""
  end
end