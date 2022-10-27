require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, owner: @user)
    @task = @project.tasks.create(name: "this is a task")
  end

  describe "#show" do
    it "responds with JSON formatted output" do
      sign_in @user
      get :show, params: {id: @task.id, project_id: @project.id}, format: :json
      expect(response.content_type).to include "application/json"
    end
  end

  describe "#create" do
    it "responds with JSON formated output" do
      new_task_params = {name: "new task"}
      sign_in @user
      post :create, params: {project_id: @project.id ,task: new_task_params}, format: :json
      expect(response.content_type).to include "application/json"
    end

    it "adds a new task to the project" do
      new_task_params = {name: "new task"}
      sign_in @user

      expect{
        post :create,
        params:
          {project_id: @project.id,
          task: new_task_params}
        }.to change(@project.tasks, :count).by(1)
    end

    it "requires authentication" do
      new_task_params = {name: "test task"}
      
      expect{
        post :create,
        params: {
          project_id: @project.id,
          task: new_task_params
        },
        format: :json
      }.to_not change(@project.tasks, :count)

      expect(response).to_not be_successful
    end
  end
end