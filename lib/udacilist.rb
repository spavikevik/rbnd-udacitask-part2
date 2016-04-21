class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] ? options[:title] : "Untitled List"
    @items = []
  end

  def add(type, description, options={})
    type = type.downcase
    @items.push TodoItem.new(description, options) if type == "todo"
    @items.push EventItem.new(description, options) if type == "event"
    @items.push LinkItem.new(description, options) if type == "link"
  end

  def delete(index)
    @items.delete_at(index - 1)
  end

  def all
    puts "-" * @title.length
    puts @title
    puts "-" * @title.length
    @items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end

  def filter(type)
    puts "-" * (@title + type_print = " | #{type.capitalize} items").length
    puts "#{@title}#{type_print}"
    puts "-" * (@title + type_print).length
    @items.select {|it| it.class.to_s == "#{type.capitalize}Item"}.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end
end
