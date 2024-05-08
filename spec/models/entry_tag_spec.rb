require 'rails_helper'

RSpec.describe EntryTag, type: :model do
  subject(:entry_tag) { EntryTag.create!(entry_id: entry.id, tag_id: tag.id) }
  let(:tag) { Tag.create!(name: "foo") }
  let(:entry) { Entry.create!(name: "bar", type_id: type.id) }
  let(:type) { Type.create!(name: "baz") }

  before do
    entry_tag
  end

  describe "accessors" do
    it "has accessors for entry and tag" do
      expect(entry_tag.entry).to eq(entry)
      expect(entry_tag.tag).to eq(tag)
    end
  end

  describe "tags" do
    it "allows access to tags linked to from an entry" do
      expect(entry.tags.to_a).to eq([tag])
    end
  end

end
