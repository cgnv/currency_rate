# frozen_string_literal: true

class Rate
  include ActiveModel::Model
  include Virtus.model

  attribute :value, Float
  attribute :expire_at, Time

  validates :value, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
  validates :expire_at, presence: true

  def initialize(opts = {})
    super
    @value = nil if @value.blank?
    @expire_at = nil if @expire_at.blank?
  end

  def self.current
    rate = admin_rate
    return rate.fake_rate if rate && rate.expire_at > Time.now

    official_rate
  end

  def self.official_rate
    rate = Rails.cache.read('usd_rub_rate')
    FetchRateJob.perform_later unless rate
    rate
  end

  def self.admin_rate
    params = Rails.cache.read('admin_rate')
    new(params) if params
  end

  def fake_rate
    { value: @value, date: Date.today }
  end

  def save
    Rails.cache.write('admin_rate', attributes) if valid?
  end
end
