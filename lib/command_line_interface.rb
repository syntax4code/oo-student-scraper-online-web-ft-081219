require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'
require 'open-uri'
require 'colorize'

class CommandLineInterface
  BASE_URL = "https://learn-co-curriculum.github.io/student-scraper-test-page/"

  def run
    make_students
    add_attributes_to_students
    display_students
  end

# this method reaches into the Scraper class from scraper.rb  and grabs students info from the students array,
# then the info is placed in a variable students_array.
  def make_students
    students_array = Scraper.scrape_index_page(BASE_URL+ 'index.html')#uses the results from scraper.rb method def self.scrape_index_page
    Student.create_from_collection(students_array)#now the info collected is placed in the Student class.
  end

  def add_attributes_to_students #
    Student.all.each do |student|
      attributes = Scraper.scrape_profile_page(BASE_URL + student.profile_url) #gets from scraper method results from def self.scrape_profile_page
      student.add_student_attributes(attributes)
    end
  end

  def display_students #this method difines how the CLI output will display
    Student.all.each do |student|
      puts "#{student.name.upcase}".colorize(:blue)
      puts "  location:".colorize(:light_blue) + " #{student.location}"
      puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
      puts "  bio:".colorize(:light_blue) + " #{student.bio}"
      puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
      puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
      puts "  github:".colorize(:light_blue) + " #{student.github}"
      puts "  blog:".colorize(:light_blue) + " #{student.blog}"
      puts "----------------------".colorize(:green)
    end
  end

end
