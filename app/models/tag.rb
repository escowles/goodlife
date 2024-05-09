class Tag < ApplicationRecord
  validates :name, presence: true
  has_many :entry_tags, dependent: :delete_all
  has_many :entries, through: :entry_tags
end
