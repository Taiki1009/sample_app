require 'rails_helper'

RSpec.describe "User pages", type: :request do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    # new
    describe "GET #new" do
        # 正常なレスポンスを返すこと
        it "returns http success" do
            get signup_path
            expect(response).to be_success
            expect(response).to have_http_status "200"
        end
    end

    describe "GET #show" do
        # ログイン済ユーザーとして
        context "as an authenticated user" do
            # 正常なレスポンスを返すこと
            it "responds successfully" do
                sign_in_as user
                get user_path(user)
                expect(response).to be_success
                expect(response).to have_http_status "200"
            end
        end

        # ログインしていないユーザーの場合
        context "as a guest" do
            # ログイン画面にリダイレクトすること
            it "redirects to the login page" do
                get user_path(user)
                expect(response).to redirect_to login_path
            end
        end

        # アカウントが違うユーザーの場合
        context "as other user" do
            before do
                @other_user = FactoryBot.create(:user)
            end
            
            # ホーム画面にリダイレクトすること
            it "redirects to the login page" do
                sign_in_as @other_user
                get user_path(user)
                expect(response).to redirect_to root_path
            end
        end
    end

    describe "#edit" do
        # 認可されたユーザーとして
        context "as an authorized user" do
            it "responds successfully" do
                sign_in_as user
                get edit_user_path(user)
                expect(response).to be_success
                expect(response).to have_http_status "200"
            end
        end

        # ログインしていないユーザーの場合
        context "as a guest" do
            # ログイン画面にリダイレクトする
            it "redirects to the login page" do
                get edit_user_path(user)
                expect(response).to have_http_status "302"
                expect(response).to redirect_to login_path
            end
        end

        context "as other user" do
            # ホーム画面にリダイレクトする
            it "redirects to the home page" do
                sign_in_as other_user
                get edit_user_path(user)
                expect(response).to redirect_to root_path
            end
        end
    end

    describe "#update" do
        # 認可されたユーザーとして
        context "as an authorized user" do
            # ユーザーを更新できること
            it "update a user" do
                user_params = FactoryBot.attributes_for(:user, name: "NewName")
                sign_in_as user
                patch user_path(user), params: { id: user.id, user: user_params }
                expect(user.reload.name).to eq "NewName"
            end
        end

        # アカウントが違うユーザーの場合
        context "as other user" do
            # ユーザーを更新できない
            it "dosen't update the user" do
                user_params = FactoryBot.attributes_for(:user, name: "NewName")
                sign_in_as other_user
                patch user_path(user), params: { id: user.id, user: user_params }
                expect(user.reload.name).to eq other_user.name
            end

            # ホーム画面にリダイレクトする
            it "redirects to the login page" do
                user_params = FactoryBot.attributes_for(:user, name: "NewName")
                sign_in_as other_user
                patch user_path(user), params: { id: user.id, user: user_params }
                expect(response).to redirect_to root_path
            end
        end
    end

    describe '#destroy' do
        context "as an authorized user" do
            # ユーザーを削除できること
            it "deletes a user" do
                sign_in_as user
                expect {
                    delete user_path(user), params: { id: user.id }
                }.to change(User, :count).by(-1)
            end
        end

        # アカウントの違うユーザーの場合
        context "as au unauthorized user" do
            # ホーム画面にリダイレクトすること
            it "redirects to the dashboard" do
                sign_in_as other_user
                delete user_path(user), params: { id: user.id }
                expect(response).to redirect_to root_path
            end
        end

        # ゲストとして
        context "as a guest" do
            it "returns a 302 response" do
                delete user_path(user), params: { id: user.id }
                expect(response).to have_http_status "302"
            end
    
            it "redirects to the sign-in page" do
                delete user_path(user), params: { id: user.id }
                expect(response).to redirect_to login_path
            end
        end
    end
end