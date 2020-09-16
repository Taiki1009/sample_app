require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_select 'form[action=?]', signup_path
    # テスト実行の前後で、User.count(ユーザー数)が変化しないか（登録失敗）
    assert_no_difference 'User.count' do
      # Name: blank, email: invalid, pass: not match & too short
      post signup_path, params: {
          user: {
            name: "",
            email: "user@invalid",
            password: "foo",
            password_confirmation: "bar"}
        }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end
end
