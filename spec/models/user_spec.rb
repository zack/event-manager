require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has many subscriptions' do
      should have_many(:subscriptions)
    end
  end
end
