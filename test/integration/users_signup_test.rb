require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # 登録失敗時のテスト
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
 
  end

  # 登録成功時のテスト
  test 'valid signupo information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {
        name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password"
      }}
    end
    # App側のコードでは、redirectでshow.erbに移行するので、それについていく
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.blank?
  end
end
