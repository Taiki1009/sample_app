require 'rails_helper'

RSpec.feature "Login", type: :feature do
    let(:user) { FactoryBot.create(:user) }

    # ログイン成功
    scenario "user successfully login" do
        valid_login(user)

        expect(current_path).to eq user_path(user)
        expect(page).to_not have_content "log in"

        # ログアウトテスト
        click_link "Log out"
        expect(current_path).to eq root_path
        expect(page).to have_content "Log in"
    end

    # ログイン失敗（無効な情報）
    scenario "user doesn't login with invalid information" do
        visit root_path
        click_link "Log in"
        fill_in "session[email]", with: ""
        fill_in "session[password]", with: ""
        click_button "Log in"
        
        expect(current_path).to eq login_path
        expect(page).to have_content "Log in"
        expect(page).to have_content "invalid email/password combination"
    end
end