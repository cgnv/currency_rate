# frozen_string_literal: true

require 'net/http'

class FetchRateJob < ApplicationJob
  queue_as :default

  def perform
    recall_time = fetch_rate_from_cbr
    retry_job recall_time
  end

  private

  def fetch_data_from(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.is_a? URI::HTTPS
    res = http.start { |htp| htp.request(req) }
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def extract_rate(xml_str)
    xml = Nokogiri::XML(xml_str)
    [xml.at_xpath('/ValCurs/Valute[@ID="R01235"]/Value').text.tr(',', '.').to_f,
     xml.at_xpath('/ValCurs')['Date'].to_date]
  end

  def memorize(value, date)
    old_rate = Rails.cache.read('usd_rub_rate')
    if old_rate.nil? || old_rate[:date] < date
      Rails.cache.write('usd_rub_rate', value: value, date: date)
    end
    if date == Date.today
      { wait_until: Date.tomorrow.beginning_of_day }
    else
      { wait: 1.hour }
    end
  end

  def fetch_rate_from_cbr
    url = 'http://www.cbr.ru/scripts/XML_daily.asp'\
      "?date_req=#{Date.today.strftime('%d/%m/%Y')}"
    data = fetch_data_from(url)
    return { wait: 1.hour } unless data

    memorize(*extract_rate(data))
  end
end
