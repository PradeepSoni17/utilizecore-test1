class Role < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	has_one :user
end
