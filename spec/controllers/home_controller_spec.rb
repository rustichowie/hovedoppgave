require 'spec_helper'




describe HomeController do
  describe 'Get #show' do
    it "shows the status of registration when you swipe your card" do
      card = Card.new(user_id: 1, card_value: "Card_valid")
      get :show, id: card
    end
  end
end
