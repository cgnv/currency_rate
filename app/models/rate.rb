class Rate
  include ActiveModel::Model

  attr_accessor :value, :expire

  def self.current
    #return value if expire > Time.now
    official_rate
  end

  def self.official_rate
    rate = Rails.cache.read('usd_rub_rate')
    FetchRateJob.perform_later unless rate && rate[:date] == Date.today
    rate
  end

  #def initialize;  end

  def to_param
  end

  def persisted?
  end

end
