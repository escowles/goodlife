module EntriesHelper
  def tag_search(tags)
    tags.map do |t|
      link_to t.name, entries_path(q: t.name)
    end.join(", ").html_safe
  end

  def people_search(people)
    people.map do |p|
      link_to p.name, entries_path(q: p.name)
    end.join(", ").html_safe
  end

  def location_search(location)
    return unless location
    location.split(",").map do |loc|
      loc.strip!
      link_to loc, entries_path(q: loc)
    end.join(", ").html_safe
  end
end
