require 'rails_helper'

# rails tutorial 3~5章のテスト
RSpec.feature "StaticPages", type: :feature do
  describe "Home page" do
    background do
      visit root_path
    end

    scenario "Browser should have the content 'Welcome to the Sample App'" do
      expect(page).to have_content "Welcome to the Sample App"
    end

    scenario "Tab should have the right title" do
      expect(page).to have_title full_title('')
    end
  end
end
