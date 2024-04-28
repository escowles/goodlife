class EntryPerson < ApplicationRecord
  belongs_to :entry
  belongs_to :person
end
