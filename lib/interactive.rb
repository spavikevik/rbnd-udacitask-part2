class Interactive
  @@lists = []

  def initialize
    @cli = HighLine.new
  end

  def main_loop
    puts "\n\nWelcome to interactive mode!".colorize(:red)
    while true
      input = @cli.ask "\nPlease select an operation:\n0) Exit\n1) New list\n2) Add/remove items to a list\n3) Print a list"
      puts "\n"
      break if input.to_i == 0
      new_list if input.to_i == 1
      edit_list if input.to_i == 2
      print_list if input.to_i == 3
    end
  end

  private

  def new_list
    title = @cli.ask "Please enter list title: "
    list = UdaciList.new(title: title)
    @@lists << list
    puts "\nList \"#{title}\" created successfully."
    add = @cli.ask "Do you want to add any items? Y/n"
    add_item(list) if add.upcase == "Y"
  end

  def edit_list
    list = get_list
    list.all
    while true
      option = @cli.ask "\n1) Add new, 2) Remove item or 3) Exit?"
      break if option.to_i == 3
      add_item(list) if option.to_i == 1
      remove_item(list) if option.to_i == 2
    end
  end

  def print_list
    list = get_list
    list.all
  end

  def add_item(list)
    while true
      options = {}
      puts "Add item: \n"
      puts "Enter arguments for new item in the following order: \ntype \ndescription/title/url \n[site-name] \n[due] \n[start] \n[end] \n[priority]\n"
      puts "\nEx: \nevent \nBook fair\n08.10.2016\n09.12.2016\n"
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
      break if add_more.upcase != "Y"
    end
  end

  def remove_item(list)
    rem_id = @cli.ask "Enter id number for item to be removed: "
    list.delete(rem_id)
  end

  def get_list
    if !@@lists.any?
      raise UdaciListErrors::NoListsError, "There are no lists."
    end
    puts "Choose a list number: "
    @@lists.each_with_index do |list, i|
      puts "#{i+1}. #{list.title}"
    end
    list = @@lists[@cli.ask("").to_i-1]
  end
end
