class ListEventsScreen < PM::TableScreen
  title "Calagator"
  stylesheet ListEventsScreenStylesheet

  def on_load
    @events = []
    load_events
  end

  def load_events
    Motion::Blitz.loading

    AFMotion::JSON.get("http://calagator.org/events.json") do |response|
      if response.success?
        @events = response.object
        update_table_data
      else
        mp response.error.localizedDescription
        mp "Oops! Somethine went wrong."
      end
    end

    Motion::Blitz.dismiss
  end

  def table_data
    [{
      title: "Upcoming Events",
      cells: @events.map do |event|
        { title: event["title"] }
      end
      }]
  end


  # You don't have to reapply styles to all UIViews, if you want to optimize, another way to do it
  # is tag the views you need to restyle in your stylesheet, then only reapply the tagged views, like so:
  #   def logo(st)
  #     st.frame = {t: 10, w: 200, h: 96}
  #     st.centered = :horizontal
  #     st.image = image.resource('logo')
  #     st.tag(:reapply_style)
  #   end
  #
  # Then in will_animate_rotate
  #   find(:reapply_style).reapply_styles#

  # Remove the following if you're only using portrait
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end
