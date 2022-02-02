#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

# Russian dates
class RussianExtd < WikipediaDate
  REMAP = {
    'Настоящее время' => '',
    'настоящее время' => '',
    'января'          => 'January',
    'январь'          => 'January',
    'февраля'         => 'February',
    'февраль'         => 'February',
    'март'            => 'March',
    'марта'           => 'March',
    'апреля'          => 'April',
    'апрель'          => 'April',
    'мая'             => 'May',
    'май'             => 'May',
    'июня'            => 'June',
    'июля'            => 'July',
    'августа'         => 'August',
    'сентября'        => 'September',
    'сентябрь'        => 'September',
    'октября'         => 'October',
    'октябрь'         => 'October',
    'ноября'          => 'November',
    'ноябрь'          => 'November',
    'декабря'         => 'December',
    'декабрь'         => 'December',
  }.freeze

  def remap
    super.merge(REMAP)
  end

  def date_str
    super.gsub(' года', '')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Председатели'
  end

  # TODO: make this easier to override
  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'#{header_column}')]][last()]//following-sibling::ul[1]//li[a]")
  end

  class Officeholder < OfficeholderBase
    def combo_date?
      true
    end

    def raw_combo_dates
      noko.text.split('—', 3).take(2).map(&:tidy)
    end

    def name_cell
      noko.css('a')
    end

    def date_class
      RussianExtd
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
