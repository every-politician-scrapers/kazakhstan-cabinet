#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.parent.css('.card-footer div').last.text.tidy
    end

    def position
      noko.parent.css('.card-footer strong').text.split(/[-–]/).map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('.row .card .card-body')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
