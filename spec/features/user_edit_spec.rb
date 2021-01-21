require 'rails_helper'

# js: true  にするとブラウザで再現してくれる
RSpec.feature "Edit", type: :feature do
    given(:user) { FactoryBot.create(:user) }

    # ユーザーは編集に成功する
    scenario "successfully edit" do
        valid_login(user)
        visit user_path(user)
        click_link "Account"
        click_link "Settings"
        expect(page).to have_content "Update your profile"

        fill_in "Email", with: "edit@example.com"
        fill_in "Password", with: "test123"
        fill_in "Confirmation", with: "test123"
        click_button "Save changes"
        
        expect(current_path).to eq user_path(user)
        user.reload
        expect(user.email).to eq "edit@example.com"
        # expect(user.password).to eq "test123"  # デバッグでは変更できているがrspecではpasswordのまま
    end

    # ユーザーは編集に失敗する
    scenario "unsuccessful edit" do
        valid_login(user)
        visit user_path(user)
        click_link "Account"
        click_link "Settings"

        fill_in "Email", with: "foo@invalid"
        fill_in "Password", with: "foo", match: :first
        fill_in "Confirmation", with: "bar"
        click_button "Save changes"

        expect(user.reload.email).to_not eq "foo@invalid"
    end

    scenario 'friendly forwarding' do
        visit user_path(user)
        valid_login(user)
        expect(current_path).to eq user_path(user)
    end
end