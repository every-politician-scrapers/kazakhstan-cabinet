#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('.staff__subtitle').text.tidy
    end

    def position
      noko.css('.staff__title').text.split(/[-–]/).map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('.staff__container .staff__item')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
