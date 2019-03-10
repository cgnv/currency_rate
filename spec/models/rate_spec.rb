# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rate, type: :model do
  let(:rate) { Rate.new(value: '1', expire_at: Time.now.to_s) }

  it { expect(Rate.new).not_to be_valid }
  it { expect(Rate.new(value: '1')).not_to be_valid }
  it { expect(Rate.new(expire_at: Time.now.to_s)).not_to be_valid }
  it { expect(Rate.new(value: 'q', expire_at: Time.now.to_s)).not_to be_valid }
  it { expect(rate).to be_valid }

  it { expect(rate).to respond_to :value }
  it { expect(rate).to respond_to :expire_at }
  it { expect(rate.fake_rate).to eq(value: 1.0, date: Date.today) }

  it 'saved into cache' do
    rate.save
    expect(Rails.cache.read('admin_rate')).to eq(value: rate.value,
                                                 expire_at: rate.expire_at)
  end

  it '.admin_rate before save' do
    Rails.cache.delete('admin_rate')
    expect(Rate.admin_rate).to be_nil
  end

  it '.admin_rate after save' do
    rate.save
    expect(Rate.admin_rate.value).to eq(rate.value)
    expect(Rate.admin_rate.expire_at).to eq(rate.expire_at)
  end

  it '.official_rate from empty cache' do
    Rails.cache.delete('usd_rub_rate')
    expect(Rate.official_rate).to be_nil
  end

  it '.official_rate from cache' do
    Rails.cache.write('usd_rub_rate', value: 10, date: Date.today)
    expect(Rate.official_rate).to eq(value: 10, date: Date.today)
  end

  it '.current after admin rate expired' do
    rate.save
    Rails.cache.write('usd_rub_rate', value: 10, date: Date.today)
    expect(Rate.current).to eq(Rate.official_rate)
  end

  it '.current before admin rate expired' do
    tomorrow_rate = Rate.new(value: 1, expire_at: Time.now.tomorrow)
    tomorrow_rate.save
    Rails.cache.write('usd_rub_rate', value: 10, date: Date.today)
    expect(Rate.current).to eq(tomorrow_rate.fake_rate)
  end
end
