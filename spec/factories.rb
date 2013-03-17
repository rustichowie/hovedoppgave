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
  factory :user do
    name "yolo"
    group_id 1
    role_id 3
    persistence_token ""
    single_access_token ""
    perishable_token ""
    login_count 0
    failed_login_count 0
    crypted_password ""
  end
end