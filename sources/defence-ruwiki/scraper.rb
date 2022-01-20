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
    'Фото'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[num name dates].freeze
    end

    def endDate
      super if raw_combo_dates.count > 1
    end

    def raw_combo_date
      super.gsub(/^с /, '').tidy rescue binding.pry
    end

    def tds
      noko.css('td,th')
    end

    def date_class
      RussianExtd
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
