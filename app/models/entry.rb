class Entry < ApplicationRecord
  validates :name, presence: true
  belongs_to :type
  has_many :entry_people, dependent: :delete_all
  has_many :people, through: :entry_people

  after_initialize do
    self.keywords ||= '||' if self.new_record?
  end

  def keywords_to_list
    (keywords || "").split(/\|/).sort.uniq.reject { |kw| kw.empty? }
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

  def self.export_csv
    CSV.generate(headers: true) do |csv|
      csv << ["id","name","description","location","date","end_date","keywords","type","people"]
      Entry.all.each do |e|
        csv << [ e.id, e.name, e.description, e.location, e.date, e.end_date,
                 e.keywords_to_list.join(","), e.type.name,e.people.map(&:name).join("|") ]
      end
    end
  end
end
