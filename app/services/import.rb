require "csv"

class Import
  def self.from_json(filename)
    data = JSON.parse(File.read(filename))
    data.each do |obj|
      entry = create_entry(obj)

      # create links
      obj["people"].map { |p| Person.find_or_create_by(name: p) }
        .each { |p| EntryPerson.create(entry_id: entry.id, person_id: p.id) }
      obj["tags"].map { |t| Tag.find_or_create_by(name: t) }
        .each { |t| EntryTag.create(entry_id: entry.id, tag_id: t.id) }
    end
  end

  def self.from_csv(filename)
    CSV.foreach(filename, headers: true) do |row|
      obj = {
        "type" => row["type"], "name" => row["name"], "date" => row["date"],
        "description" => row["description"], "location" => row["location"]
      }
      entry = create_entry(obj)
      ["p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "p16", "p17", "p18", "p19"].each do |person_field|
        val = row[person_field]
        if val
          person = Person.find_or_create_by(name: val)
          EntryPerson.create(entry_id: entry.id, person_id: person.id)
        end
      end
      ["t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9", "t10"].each do |tag_field|
        val = row[tag_field]
        if val
          tag = Tag.find_or_create_by(name: val)
          EntryTag.create(entry_id: entry.id, tag_id: tag.id)
        end
      end
    end
  end

  private

    def self.create_entry(obj)
      attrib = obj.except("id", "created_at", "updated_at", "type", "tags", "people")
      type = Type.find_or_create_by(name: obj["type"])
      puts "creating: #{attrib}"
      Entry.create(type_id: type.id, **attrib)
    end
end
