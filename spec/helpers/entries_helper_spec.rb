require "rails_helper"

RSpec.describe EntriesHelper, type: :helper do
  let(:tag) { Tag.create!(name: "foo") }
  let(:person) { Person.create!(name: "bar") }
  let(:location) { "US-CA-San Diego" }

  describe "#keyword_search" do
    it "links to a search for the keyword" do
      html = %{<a href="/entries?keyword=foo">foo</a>}
      expect(helper.keyword_search(["foo"])).to eq(html)
    end
  end
  describe "#tag_search" do
    it "links to a search for the tag" do
      html = %{<a href="/entries?tag=#{tag.id}">foo</a>}
      expect(helper.tag_search([tag])).to eq(html)
    end
  end
  describe "#people_search" do
    it "links to a search for the person" do
      html = %{<a href="/entries?person=#{person.id}">bar</a>}
      expect(helper.people_search([person])).to eq(html)
    end
  end
  describe "#location_search" do
    it "links to a search for the person" do
      html = %{<a href="/entries?q=US-CA-San+Diego">US-CA-San Diego</a>}
      expect(helper.location_search(location)).to eq(html)
    end
  end
end
