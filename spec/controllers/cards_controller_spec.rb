require 'spec_helper'

describe CardsController do

  let(:user) {User.find(9)}
  let(:card){Card.find(56)}
  describe "GET 'new'" do
    it "returns http success" do
      get 'new', user_id: user.id
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', user_id: user.id
      response.should be_success
    end
  end


  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', user_id: user.id, id: card.id
      response.should be_success
    end
  end

end
