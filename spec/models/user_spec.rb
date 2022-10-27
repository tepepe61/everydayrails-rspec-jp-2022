require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valiid factory" do

    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is valid with a first name, last name, email, and password" do
    user = User.new(
      first_name: "Aaron",
      last_name: "Sumner",
      email: "testerr@example.com",
      password: "password_test"
    )
    expect(user).to be_valid
  end

  it "is invalid without a first name" do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "is invalid without a last name" do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?

    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # it "is invalid without an email address"
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "aaaron@example.com")
    user = FactoryBot.build(:user, email: "aaaron@example.com")

    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "returns a users full name a string" do
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq "John Doe"
  end

  it "does something with multiple users" do
    user_1 = FactoryBot.create(:user)
    user_2 = FactoryBot.create(:user)

    expect(true).to be_truthy
  end
end
