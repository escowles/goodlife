require 'rails_helper'

RSpec.describe Person, type: :model do
  subject(:person) { Person.create!(name: "foo") }
  let(:entry) { Entry.create!(name: "bar", type_id: type.id) }
  let(:type) { Type.create!(name: "baz") }

  before do
    EntryPerson.create!(entry_id: entry.id, person_id: person.id)
  end

  describe "properties" do
    it "has properties" do
      expect(person.name).to eq("foo")
    end
  end

  describe "entries" do
    it "allows access to entries that link to this tag" do
      expect(person.entries.to_a).to eq([entry])
    end
  end
end
