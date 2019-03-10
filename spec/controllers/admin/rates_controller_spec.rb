# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::RatesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'render index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    context 'with invalid params' do
      it 'returns http success' do
        post :create, params: { rate: { value: '', expire_at: '' } }
        expect(response).to have_http_status(:success)
      end

      it 'render index template' do
        post :create, params: { rate: { value: '', expire_at: '' } }
        expect(response).to render_template(:index)
      end
    end

    context 'with valid params' do
      it 'redirects to #index' do
        post :create, params: { rate: { value: '1', expire_at: Time.now.to_s } }
        expect(response).to redirect_to(%i[admin rates])
      end
    end
  end
end
