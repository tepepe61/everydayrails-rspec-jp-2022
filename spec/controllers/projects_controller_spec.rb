require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "responds successfull" do
        sign_in @user
        get :index
        expect(response).to be_successful
      end

      it "returns a 200 response" do
        sign_in @user
        get :index
        expect(response).to have_http_status 200
      end
    end

    context "as a guest" do
      it "returns a 302 response"do
        get :index
        expect(response).to have_http_status '302'
      end

      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "resoponds successfully" do
        sign_in @user
        get :show, params: {id: @project.id}
        expect(response).to be_successful
      end
    end

    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "redirects to the dashboard" do
        sign_in @user
        get :show, params: {id: @project.id}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      context "with valid attributes" do
        it "adds a project" do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect{post :create, params: {project: project_params}}.to change(@user.projects, :count).by(1)
        end
      end

      context "wiht invalid attributes" do
        it "does not add a project" do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user

          expect{post :create, params: {project: project_params}}.to_not change(@user.projects, :count)
        end
      end
    end

    context "as an guest" do
      it "returns a 302 response " do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: {project: project_params}

        expect(response).to have_http_status "302"
      end

      it "redirext to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: {project: project_params}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # updateって言っても、既存のprojectの一部を変更する処理のことだから、既存のprojectと変更したい値を用意すればいいだけなのか
      it "updates a project" do
        project_params = FactoryBot.attributes_for(:project, name: "NEW PROJECT NAME")
        sign_in @user
        patch :update, params: {id: @project.id, project: project_params}

        expect(@project.reload.name).to eq "NEW PROJECT NAME"
      end
    end

    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        # updateができないことを知りたいなら、updateができては困る条件を作ればいいだけ。今回なら持ち主が異なるprojectを更新できるかをチェック
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user, name: "Same Old Name")
      end

      it "does not update the project" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        put :update, params: {id: @project.id, project: project_params}
        expect(@project.reload.name).to eq "Same Old Name"

      end

      it "redirects to the dashbord" do
        sign_in @user
        project_params = FactoryBot.create(:project, owner: @user)
        put :update, params: {id: @project.id, project: project_params}
        expect(response).to redirect_to root_path
      end
    end

    context "as a guest" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project)
      end

      it "returns a 302 response" do
        # sign_in @user
        project_params = FactoryBot.attributes_for(:project, name: "test")
        put :update, params: {id: @project.id, project: project_params}
        expect(response).to have_http_status "302"
      end

      it "redirect to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        path :update, params: {id: @project.id, project: project_params}
        expect(response).to redirect_to '/users/sing_in'
      end
    end
  end

  describe "#destroy" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "delete a project" do
        sign_in @user
        # delete :destroy, params: {id: @project.id}
        expect{delete :destroy, params: {id: @project.id}}.to change(@user.projects, :count).by(-1)
      end
    end

    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @other_user)
      end

      it "does not delete the project" do
        sign_in @user
        expect{delete :destroy, params: {id: @project.id}}.to_not change(Project, :count)
      end

      it "redirect to dashbord" do
        sign_in @user
        delete :destroy, params: {id: @project.id}
        expect(response).to redirect_to root_path
      end
    end

    context "as a guest" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "returns a 302 response" do
        delete :destroy, params: {id: @project.id}
        expect(response).to have_http_status '302'
      end

      it "redirect to the sign-in page" do
        delete :destroy, params: {id: @project.id}
        expect(response).to redirect_to "/users/sign_in"
      end

      it "dose not delete the project" do
        expect{delete :destroy, params: {id: @project.id}}.to_not change(Project, :count)
      end
    end
  end
end



