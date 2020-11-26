require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |studentcard|#access the element with container name and iterate through it
       studentcard.css(".student-card a").each do |student|
          studentlink = student.attr('href')
          studentlocation = student.css(".student-location").text
          studentname = student.css(".student-name").text
          students << {name: studentname, location: studentlocation, profile_url: studentlink}
       end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    links = profile_page.css(".social-icon-container").children.css("a").map { |element| element.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = profile_page.css(".profile-quote").text
    student[:bio] = profile_page.css("div.description-holder p").text
    #find out if div.bio-content.content-holder div.description-holder p is better than the above
    student
  end

end

