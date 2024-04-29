module EntriesHelper
  def tag_links(tags)
    tags.map do |t|
      link_to t.name, tag_path(t)
    end.join(", ").html_safe
  end

  def people_links(people)
    people.map do |p|
      link_to p.name, person_path(p)
    end.join(", ").html_safe
  end
end
