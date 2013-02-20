require 'spec_helper'

describe User do
      it "should have a name" do
        foo = User.new(:name=>"")
        foo.should_not be_valid
      end
    
    
end
