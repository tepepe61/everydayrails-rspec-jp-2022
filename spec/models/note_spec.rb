require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = User.create!(
      first_name: "Joe",
      last_name: "Tester",
      email: "test2@example.com",
      password: "password"
    )

    @project = @user.projects.create(
      name: "TEST PROJECT"
    )
  end

  # 文字列に一致するメッセージを検索する
  describe "search message for a term" do
    before do
      @note1 = @project.notes.create(
        message: "This is the first note.",
        user: @user
      )
      @note2 = @project.notes.create(
        message: "This is the second note.",
        user: @user
      )
      @note3 = @project.notes.create(
        message: "First, preheat the oven.",
        user: @user
      )
    end

    # 一致するデータが見つかる時
    context "when a match is found" do
      # 検索文字列に一致するメモを返すこと
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(@note1, @note3)
      end
    end

    #一致するデータが一見も見つからない時
    context "when no match is foun" do
      # 空のコレクションを返すこと
      it "returns an empty collection when no results are found" do
        expect(Note.search("message")).to be_empty
      end
    end
  end

  it "generates associated data from a factory" do
    note = FactoryBot.create(:note)
    puts "This note's projects is #{note.project.inspect}"
    puts "This note's user is #{note.user.inspect}"
  end
end


