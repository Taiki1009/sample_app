require 'rails_helper'

RSpec.feature "SignUps", type: :feature do
  include ActiveJob::TestHelper

  # サインアップ成功
  scenario "user successfully signs up" do
    visit root_path
    click_link "Sign up now!"

    perform_enqueued_jobs do
      expect {
        fill_in "Name", with: "Example"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
        click_button "Create my account"
      }.to change(User, :count).by(1)

      expect(page).to have_content "Please check your email to activate your account"
      expect(current_path).to eq root_path
    end

    # アカウント有効化メールのテスト
    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ["user@example.com"]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "Account activation"
    end
  end
end
