class Task < ApplicationRecord
  enum :status, [:to_do, :in_progress, :in_testing, :rejected, :done]

  belongs_to :project

  validates :title, presence: true
end
