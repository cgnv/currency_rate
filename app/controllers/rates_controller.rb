# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    @rate = Rate.current || {}
    respond_to do |format|
      format.html
      if @rate.present?
        format.json { render json: @rate, status: :ok }
      else
        format.json { render json: nil, status: :service_unavailable }
      end
    end
  end
end
