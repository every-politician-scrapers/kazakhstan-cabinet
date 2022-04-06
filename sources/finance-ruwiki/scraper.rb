#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Министры Казахстана'
  end

  # TODO: make this easier to override
  def holder_entries
    noko.xpath("//h3[.//span[contains(.,'#{header_column}')]][last()]//following-sibling::ol//li[a]")
  end

  class Officeholder < OfficeholderBase
    def combo_date?
      true
    end

    def raw_combo_dates
      noko.xpath('text()').text.gsub(' с ', '').gsub(' года', '').split(/[—-]/).map(&:tidy).reject(&:empty?)
    end

    def raw_end
      super.to_s
    end

    def name_cell
      noko.css('a')
    end

    def empty?
      false
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
