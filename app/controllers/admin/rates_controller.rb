# frozen_string_literal: true

class Admin::RatesController < ApplicationController
  def index
    @rate = Rate.admin_rate || Rate.new
  end

  def create
    @rate = Rate.new(rate_params)
    @rate.expire_at = ActiveSupport::TimeZone.new(params[:user][:time_zone])
                                             .local_to_utc(@rate.expire_at)
    if @rate.save
      redirect_to %i[admin rates], success: 'Курс изменен'
    else
      render :index
    end
  end

  private

  def rate_params
    params.require(:rate).permit(:value, :expire_at)
  end
end
