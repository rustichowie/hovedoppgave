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
  factory :valid_user, :class => User do |u|
     
    u.name 'Example User' 
    u.email 'user@example.com'
    u.group_id 1
    u.role_id 3
    u.password 'foobar'
    u.password_confirmation 'foobar'
    u.persistence_token '3599dd54eecaa2730014cb82a11f31f93075d73f4f072e15ea974f2691ffc85d8fd927d2b133a451791aa0417ead80f05828d6cb88e52dab1a3b4c6d50d5f8d5'
    

  end
  factory :new_valid_user, :class => User do |u|
     
    u.name 'Example User' 
    u.email 'user@example.com'
    u.group_id 1
    u.role_id 1
    u.password 'foobar'
    u.password_confirmation 'foobar'
    u.persistence_token '3599dd54eecaa2730014cb82a11f31f93075d73f4f072e15ea974f2691ffc85d8fd927d2b133a451791aa0417ead80f05828d6cb88e52dab1a3b4c6d50d5f8d5'
    

  end
  
end

