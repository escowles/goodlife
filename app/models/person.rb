class Person < ApplicationRecord
  has_many :entry_people
  has_many :entries, through: :entry_people
end
