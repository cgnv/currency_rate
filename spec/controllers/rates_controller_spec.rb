# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns admin rate in json' do
      Rails.cache.write('admin_rate', value: 60, expire_at: Time.now.tomorrow)
      Rails.cache.write('usd_rub_rate', value: 65, date: Date.today)
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['value']).to eq(60.0)
    end

    it 'returns oficial rate in json' do
      Rails.cache.write('usd_rub_rate', value: 65, date: Date.today)
      Rails.cache.delete('admin_rate')
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns empty json' do
      Rails.cache.delete('usd_rub_rate')
      Rails.cache.delete('admin_rate')
      get :index, format: :json
      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
