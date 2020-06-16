require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students_array = []
    parsed_page = Nokogiri::HTML(open(index_url))
    students_html = parsed_page.css("div.student-card")

    students_html.each do |student|
      student_hash = {
        name: student.css('h4.student-name').text,
        location: student.css('p.student-location').text,
        profile_url: student.css('a').attribute('href').value
      }

      students_array << student_hash

    end

    students_array

  end

  def self.scrape_profile_page(profile_url)
    parsed_page = Nokogiri::HTML(open(profile_url))

    student_profile_hash = {
      :profile_quote=>parsed_page.css('div.profile-quote').text,
      :bio=>parsed_page.css('div.description-holder > p').text
    }

    parsed_page.css('div.social-icon-container > a').each do |social|
      # social_img = social['children'][1]['children']
      social_img = social.css('img').attribute('src').value
      # binding.pry
      if social_img == '../assets/img/twitter-icon.png'
        student_profile_hash[:twitter] = social.attribute('href').value
      elsif social_img == '../assets/img/linkedin-icon.png'
        student_profile_hash[:linkedin] = social.attribute('href').value
      elsif social_img == '../assets/img/github-icon.png'
        student_profile_hash[:github] = social.attribute('href').value
      elsif social_img == '../assets/img/rss-icon.png'
        student_profile_hash[:blog] = social.attribute('href').value
      end
    end
    
    # binding.pry
    student_profile_hash

  end

end

