require 'rails_helper'

RSpec.describe Type, type: :model do
  subject(:type) { Type.create!(name: "foo") }
  let(:entry) { Entry.create!(name: "bar", type_id: type.id) }

  before do
    entry
  end

  describe "properties" do
    it "has properties" do
      expect(type.name).to eq("foo")
    end
  end

  describe "entries" do
    it "allows access to entries that link to this tag" do
      expect(type.entries.to_a).to eq([entry])
    end
  end
end
