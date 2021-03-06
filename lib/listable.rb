module Listable
  # Listable methods go here
  def format_description(description)
    "#{description}".ljust(30)
  end

  def format_date(options = {})
    dates = options[:default]
    dates = options[:due].strftime("%D") if options[:due]
    dates = options[:start_date].strftime("%D") if options[:start_date]
    dates << " -- " + options[:end_date].strftime("%D") if options[:end_date]
    dates
  end

  def format_priority(priority)
    case priority
    when "high"
      return " ⇧".colorize(:red)
    when "medium"
      return " ⇨".colorize(:yellow)
    when "low"
      return " ⇩".colorize(:green)
    else
      ""
    end
  end
end
