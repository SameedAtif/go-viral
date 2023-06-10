class ProjectPlatform < ApplicationRecord
  belongs_to :project
  belongs_to :platform
end
