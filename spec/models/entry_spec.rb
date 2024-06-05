require 'rails_helper'

RSpec.describe Entry, type: :model do
  subject(:entry) { Entry.create!(name: "foo", type_id: type.id, description: "this is a thing",
                                  date: "2024-05-01", end_date: "2024-05-22", keywords: "|aa|zz|") }
  let(:type) { Type.create!(name: "bar") }
  let(:tag) { Tag.create!(name: "baz") }
  let(:person) { Person.create!(name: "quux") }

  before do
    EntryTag.create!(entry_id: entry.id, tag_id: tag.id)
    EntryPerson.create!(entry_id: entry.id, person_id: person.id)
  end

  describe "keywords_to_list" do
    it "converts keywords field to an array of strings" do
      expect(entry.keywords_to_list).to eq(["aa", "zz"])
    end
  end
  describe "tags" do
    it "allows access to tags linked to this entry" do
      expect(entry.tags.to_a).to eq([tag])
    end
  end

  describe "people" do
    it "allows access to people linked to this entry" do
      expect(entry.people.to_a).to eq([person])
    end
  end

  describe "export_json" do
    it "exports data" do
      export = JSON.parse(entry.export_json)
      expect(export["name"]).to eq(entry.name)
      expect(export["date"]).to eq(entry.date)
      expect(export["end_date"]).to eq(entry.end_date)
      expect(export["description"]).to eq(entry.description)
      expect(export["type"]).to eq(type.name)
      expect(export["tags"]).to eq([tag.name])
      expect(export["people"]).to eq([person.name])
    end
  end

  describe "export_all" do
    it "exports data" do
      export = JSON.parse(Entry.export_all).first
      expect(export["name"]).to eq(entry.name)
      expect(export["type"]).to eq(type.name)
      expect(export["tags"]).to eq([tag.name])
      expect(export["people"]).to eq([person.name])
    end
  end
end
