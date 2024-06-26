module EntriesHelper
  def keyword_search(keywords)
    keywords.map do |kw|
      link_to kw, entries_path(keyword: kw)
    end.join(", ").html_safe
  end

  def people_search(people)
    people.map do |p|
      link_to p.name, entries_path(person: p.id)
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
