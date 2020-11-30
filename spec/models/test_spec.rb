require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { FactoryBot.create(:user) }

    describe User do
        # ファクトリが有効か
        it "has a valid factory" do
            expect(user).to be_valid
        end
    end

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_presence_of :email }
    

end