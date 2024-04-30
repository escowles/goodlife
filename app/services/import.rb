class Import
  def self.from_file(filename)
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

  private

    def self.create_entry(obj)
      attrib = obj.except("id", "created_at", "updated_at", "type", "tags", "people")
      type = Type.find_or_create_by(name: obj["type"])
      puts "creating: #{attrib}"
      Entry.create(type_id: type.id, **attrib)
    end
end
