class Interactive
  @@lists = []

  def initialize
    @cli = HighLine.new
  end

  def main_loop
    puts "\n\nWelcome to interactive mode!".colorize(:red)
    while true
      input = @cli.ask "Please select an operation:\n0) Exit\n1) New list\n2) Add/remove items to a list\n3) Print a list"
      break if input.to_i == 0
      new_list if input.to_i == 1
    end
  end

  def new_list
    title = @cli.ask "\nPlease enter list title: "
    list = UdaciList.new(title: title)
    @@lists << list
    puts "\nList \"#{title}\" created successfully."
    add = @cli.ask "Do you want to add any items? Y/n"
    add_item(list) if add.upcase == "Y"
  end

  def print_list
    puts "Choose a list to print: "
    @@lists.each_with_index do |list, i|
      puts "#{i}. #{list.title}"
    end

  def add_item(list)
    puts "Editing list \"#{list.title}\": "
    while true
      options = {}
      puts "\nAdd item: \n"
      puts "Enter arguments for new item in the following order: \ntype \ndescription/title/url \n[site-name] \n[due] \n[start] \n[end] \n[priority]\n"
      puts "\nEx: \nBook fair \nevent\n08.10.2016\n09.12.2016\n"
      type = @cli.ask("\n").downcase
      description = @cli.ask ""
      options[:site_name] = @cli.ask("") if type == "link"
      options[:due] = @cli.ask("") if type == "todo"
      options[:start_date] = @cli.ask("") if type == "event"
      options[:end_date] = @cli.ask("") if type == "event"
      options[:priority]  = @cli.ask("").downcase if type == "todo"
      list.add(type, description, options)
      puts "Added item \"#{description}\":\n\n"
      list.all
      add_more = @cli.ask "Add more? Y/n"
      if add_more.upcase != "Y"
        break
      end
    end
  end
end
