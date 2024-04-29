class Entry < ApplicationRecord
  belongs_to :type
  has_many :entry_people
  has_many :entry_tags
  has_many :people, through: :entry_people
  has_many :tags, through: :entry_tags
end
