class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] ? options[:title] : "Untitled List"
    @items = []
  end

  def add(type, description, options={})
    type = type.downcase
    if options[:priority] && !has_valid_priority?(options[:priority])
      raise UdaciListErrors::InvalidPriorityValueError, "'#{options[:priority]}' is not a valid priority."
    end
    case type
    when "todo"
      @items.push TodoItem.new(description, options)
    when "event"
      @items.push EventItem.new(description, options)
    when "link"
      @items.push LinkItem.new(description, options)
    else
      raise UdaciListErrors::InvalidItemTypeError, "'#{type}' is not a valid item type."
    end
  end

  def delete(index)
    raise UdaciListErrors::IndexExceedsListSizeError, "index #{index} exceeds list size." unless index.to_i < @items.count
    @items.delete_at(index - 1)
  end

  def all
    puts "-" * @title.length
    puts @title
    puts "-" * @title.length
    @items.each_with_index do |item, position|
      puts "#{position + 1}) (#{item.class.to_s.tap {|s| s.slice!("Item")}.downcase})  #{item.details}"
    end
  end

  def filter(type)
    type = type.downcase
    raise UdaciListErrors::InvalidItemTypeError, "'#{type}' is not a valid item type." unless has_valid_type?(type)
    filtered_list = filter_helper(type)
    if !filtered_list
      puts "No items of type #{type}!".colorize(:red)
    end
    puts "-" * (@title + type_print = " | #{type.capitalize} items").length
    puts "#{@title}#{type_print}".colorize(:blue)
    puts "-" * (@title + type_print).length
    filtered_list.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end

  private

  def filter_helper(type)
    @items.select {|it| it.class.to_s == "#{type.capitalize}Item"}
  end

  def has_valid_type?(type)
    types = ["event", "todo", "link"]
    types.include?(type)
  end

  def has_valid_priority?(priority)
    priorities = ["low", "medium", "high"]
    priorities.include?(priority)
  end
end
