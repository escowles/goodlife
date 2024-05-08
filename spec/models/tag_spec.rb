require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject(:tag) { Tag.create!(name: "foo") }
  let(:entry) { Entry.create!(name: "bar", type_id: type.id) }
  let(:type) { Type.create!(name: "baz") }

  before do
    EntryTag.create!(entry_id: entry.id, tag_id: tag.id)
  end

  describe "properties" do
    it "has properties" do
      expect(tag.name).to eq("foo")
    end
  end

  describe "entries" do
    it "allows access to entries that link to this tag" do
      expect(tag.entries.to_a).to eq([entry])
    end
  end
end
