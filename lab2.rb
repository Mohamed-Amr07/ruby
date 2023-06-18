class Person
    attr_accessor :name
  
    def valid_name?
      /^[a-zA-Z]+$/.match?(name)
    end
  end
  
  module Contactable
    def contact_details
      "#{email} | #{mobile}"
    end
  end
  
  class User < Person
    include Contactable
    attr_accessor :email, :mobile
  
    def create
      if valid_name? && valid_mobile?
        register_user
        puts "Welcome, #{name}"
        self
      else
        puts "Sorry, registration failed. Please provide valid data."
        false
      end
    end
  
    def valid_mobile?
      /^\d{11}$/.match?(mobile)
    end
  
    def self.list(n = nil)
      users = read_users
      if n.nil? || n == "*"
        users.each { |user| puts "#{user.name}: #{user.contact_details}" }
      else
        users.first(n.to_i).each { |user| puts "#{user.name}: #{user.contact_details}" }
      end
    end
  
    private
  
    def register_user
      user_data = "#{name},#{email},#{mobile}"
      File.open('users.txt', 'a') { |file| file.puts(user_data) }
    end
  
    def self.read_users
      users = []
      File.open('users.txt', 'r') do |file|
        file.each_line do |line|
          name, email, mobile = line.strip.split(',')
          user = User.new
          user.name = name
          user.email = email
          user.mobile = mobile
          users << user
        end
      end
      users
    end
  end
    
  loop do
    puts
    puts 'Choose an option:'
    puts '1. Create a new user'
    puts '2. List all users'
    choice = gets.chomp.to_i
  
    case choice
    when 1
      puts 'Name:'
      name = gets.chomp
  
      puts 'Email:'
      email = gets.chomp
  
      puts 'Mobile:'
      mobile = gets.chomp
  
      user = User.new
      user.name = name
      user.email = email
      user.mobile = mobile
  
      registered_user = user.create
  
      puts
      puts 'List all users'
      User.list('*')
  
      puts
      puts 'List first n users'
      puts 'Enter (*) to list all registered users or the number of users you would like to list:'
      n = gets.chomp
      User.list(n)
  
    when 2
      puts 'List all users'
      User.list('*')
  
      puts
      puts 'List first n users'
      puts 'Enter (*) to list all registered users or the number of users you would like to list:'
      n = gets.chomp
      User.list(n)
  
    else
      puts 'Invalid choice. Please try again.'
    end
  end
  