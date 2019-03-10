# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchRateJob, type: :job do
  describe '#perform_later' do
    it 'fetch rate' do
      ActiveJob::Base.queue_adapter = :test
      expect { FetchRateJob.perform_later }.to have_enqueued_job
    end
  end

  describe '.fetch_rate_from_cbr' do
    let(:url) do
      'http://www.cbr.ru/scripts/XML_daily.asp'\
      "?date_req=#{Date.today.strftime('%d/%m/%Y')}"
    end

    let(:body) do
      %(<ValCurs Date="#{Date.today.strftime('%d.%m.%Y')}">)\
      '<Valute ID="R01235"><Value>65,9646</Value></Valute></ValCurs>'
    end

    before { stub_request(:get, url).to_return(status: 200, body: body) }

    it 'fetch right value' do
      Rails.cache.delete('usd_rub_rate')
      FetchRateJob.perform_now
      expect(Rails.cache.read('usd_rub_rate'))
        .to eq(value: 65.9646, date: Date.today)
    end
  end
end
