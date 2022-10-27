FactoryBot.define do
  factory :note do
    message {"sss"}
    association :project
    user {project.owner}
  end
end
