require 'rails_helper'

RSpec.describe Project, type: :model do
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: "JOE",
      last_name: "TESTER",
      email: "test@example.com",
      password: "password"
    )

    user.projects.create(
      name: "TEST PROJECT"
    )

    new_projects = user.projects.build(
      name: "TEST PROJECT"
    )

    new_projects.valid?
    expect(new_projects.errors[:name]).to include("has already been taken")
  end

  it "allows two users to share a project name" do
    user1 = User.create(
      first_name: "TARO1",
      last_name: "SUZUKI1",
      email: "test1@example.com",
      password: "password"
    )

    user2 = User.create(
      first_name: "TARO2",
      last_name: "SUZUKI2",
      email: "test2@example.com",
      password: "password"
    )

    user1.projects.create(
      name: "TEST PROJECTSSSS"
    )

    user2_project = user2.projects.build(
      name: "TEST PROJECTSSSS"
    )

    expect(user2_project).to be_valid
  end

  describe 'late status' do
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :project_due_yesterday)
      expect(project).to be_late
    end

    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :project_due_today)
      expect(project).to_not be_late
    end

    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project, :project_due_tomorrow)
      expect(project).to_not be_late
    end

    it "can have many notes" do
      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.length).to eq 5
    end
  end
end








