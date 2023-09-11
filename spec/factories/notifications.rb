FactoryBot.define do
  factory :notification do
    resource_type { 'Project' }
    resource_id { create(:project).id }
    notification_type { Notification::NOTIFICATION_TYPES_MAP[:new_project_request] }
    user_type { 'reviewer' }
    user
  end
end
