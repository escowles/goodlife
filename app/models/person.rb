class Person < ApplicationRecord
  validates :name, presence: true
  has_many :entry_people, dependent: :delete_all
  has_many :entries, through: :entry_people
end
