module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "TL Mafia Queue"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def sortable(column, title=nil)
    title ||=column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "ASC" ? "DESC" : "ASC"
    link_to title, params.merge(sort: column, direction: direction, page: nil), { class: css_class }
  end
end
