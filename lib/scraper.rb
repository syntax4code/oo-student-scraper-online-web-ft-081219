require 'nokogiri'
require 'open-uri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url) #is a class method that scrapes the student index page and a returns an array of hashes in which each hash represents one student
      index_page = Nokogiri::HTML(open(index_url)) #opens the page that our scraper will use to scrape info
      students = [] #empty array for temporary placeholder for student info
      index_page.css("div.roster-cards-container").each do |card| #uses the nokogiri .css method <div class="roster-cards-container">
        card.css(".student-card a").each do |student| #<a href="students/ryan-johnson.html">

          student_profile_link = "#{student.attr('href')}" #this uses the profile link from the index page to get info from each individuals profile
          student_location = student.css('.student-location').text #uses the css method to parse the location text from the profile
          student_name = student.css('.student-name').text # parses the student name text
          students << {name: student_name, location: student_location, profile_url: student_profile_link} # pushes all the text parsed above into a hash
        end
      end
      students
    end

    def self.scrape_profile_page(profile_slug)# responsible for scraping an individual student's profile page for social media links
    student = {}
    profile_page = Nokogiri::HTML(open(profile_slug))
    #the line below parses through the
    links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin") #if the student has a linkedin account adds the link to the student hash
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
end
student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote") #parses the profile page for the profile quote and adds the value to the student hash.

  student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end
