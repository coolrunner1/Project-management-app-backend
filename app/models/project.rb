class Project < ApplicationRecord
    belongs_to :user

    validates :title, presence: true

    def as_json(options = {})
        super({ except: [:user_id] }.merge(options))
    end
end
