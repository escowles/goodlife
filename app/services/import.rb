require "csv"

class Import
  def self.from_json(filename, clear: false)
    clear_entries if clear
    data = JSON.parse(File.read(filename))
    data.each do |obj|
      entry = create_entry(obj)

      # create links
      obj["people"].map { |p| Person.find_or_create_by(name: p) }
        .each { |p| EntryPerson.create(entry_id: entry.id, person_id: p.id) }
    end
  end

  def self.from_csv(filename, clear: false)
    clear_entries if clear
    CSV.foreach(filename, headers: true) do |row|
      obj = {
        "type" => row["type"], "name" => row["name"], "date" => row["date"],
        "end_date" => row["end_date"], "description" => row["description"],
        "location" => row["location"]
      }
      entry = create_entry(obj)
      ["p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "p16", "p17", "p18", "p19"].each do |person_field|
        val = row[person_field]
        if val
          person = Person.find_or_create_by(name: val)
          EntryPerson.create(entry_id: entry.id, person_id: person.id)
        end
      end
    end
  end

  private

    def self.clear_entries
      EntryPerson.delete_all
      Entry.delete_all
    end
    def self.create_entry(obj)
      attrib = obj.except("id", "created_at", "updated_at", "type", "people")
      type = Type.find_or_create_by(name: obj["type"])
      Entry.create(type_id: type.id, **attrib)
    end
end
