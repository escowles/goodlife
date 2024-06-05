class Entry < ApplicationRecord
  validates :name, presence: true
  belongs_to :type
  has_many :entry_people, dependent: :delete_all
  has_many :people, through: :entry_people

  def keywords_to_list
    (keywords || "").split(/\|/).reject { |kw| kw.empty? }
  end

  def export_data
    data = self.attributes.except("type_id")
    data["type"] = self.type.name
    data["people"] = self.people.map(&:name)
    data
  end

  def export_json
    self.export_data.to_json
  end

  def self.export_all
    Entry.all.map(&:export_data).to_json
  end
end
