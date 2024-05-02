class Person < ApplicationRecord
  has_many :entry_people, dependent: :delete_all
  has_many :entries, through: :entry_people
end
