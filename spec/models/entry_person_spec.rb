require 'rails_helper'

RSpec.describe EntryPerson, type: :model do
  subject(:entry_person) { EntryPerson.create!(entry_id: entry.id, person_id: person.id) }
  let(:person) { Person.create!(name: "foo") }
  let(:entry) { Entry.create!(name: "bar", type_id: type.id) }
  let(:type) { Type.create!(name: "baz") }

  before do
    entry_person
  end

  describe "accessors" do
    it "has accessors for entry and person" do
      expect(entry_person.entry).to eq(entry)
      expect(entry_person.person).to eq(person)
    end
  end

  describe "people" do
    it "allows access to people linked to from an entry" do
      expect(entry.people.to_a).to eq([person])
    end
  end
end
