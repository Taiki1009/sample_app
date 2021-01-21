require 'rails_helper'

RSpec.describe "Remember me", type: :request do
    let(:user) { FactoryBot.create(:user) }

    # 2つのバグのテスト-1
    context "with valid information" do
        # ログイン中のみログアウトすること
        it "logs in with valid information followed by logout" do
            sign_in_as(user)
            expect(response).to redirect_to user_path(user)

            # ログアウトすること
            delete logout_path
            expect(response).to redirect_to root_path
            expect(session[:user_id]).to eq nil

            # 2番目のウィンドウでログアウトする
            delete logout_path
            expect(response).to redirect_to root_path
            expect(session[:user_id]).to eq nil
        end
    end

    # ２つのバグのテスト-2
    context "authenticated? should return false for a user with nil digest" do
        # ダイジェストが存在しない場合のauthenticated?のテスト
        it "is invalid without remember_digest" do
            expect(user.authenticated?(:remember, '')).to eq false
        end
    end

    context "login with remembering" do
        it "remembers cookies" do
            post login_path, params: { session: {
                email: user.email,
                password: user.password,
                remember_me: '1' } }
                expect(response.cookies['remember_token']).to_not eq nil
        end
    end

    context "login without remembering" do
        it "dosen't remember cookies" do
            # クッキーを保存してログイン
            post login_path, params: { session: {
                email: user.email,
                password: user.password,
                remember_me: '1' } }
            delete logout_path

            # クッキーを保存せずにログイン
            post login_path, params: { session: { 
                email: user.email,
                password: user.password,
                remember_me: '0' } }
            expect(response.cookies['remember_token']).to eq nil
        end
    end

end