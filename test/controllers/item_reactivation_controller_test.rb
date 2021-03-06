require 'test_helper'

class ItemReactivationControllerTest < ActionController::TestCase

  test 'reactivate item' do
    offer = offers(:roommate_wanted)
    offer.updated_at = 40.days.ago
    offer.save
    reactivator = ItemReactivator.create! item: offer

    post :reactivate, :token => reactivator.token

    offer = Offer.find(offer.id)
    assert offer.updated_at > 5.minutes.ago
  end

  test 'reactivating item confirms user with unconfirmed email' do
    offer = offers(:roommate_wanted)
    offer.updated_at = 40.days.ago
    offer.save
    reactivator = ItemReactivator.create! item: offer

    user = users(:john)
    assert_nil user.confirmed_at

    post :reactivate, :token => reactivator.token

    offer = Offer.find(offer.id)
    user = User.find(user.id)
    assert offer.updated_at > 5.minutes.ago
    assert_not_nil user.confirmed_at
  end

end