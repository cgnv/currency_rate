class RatesController < ApplicationController
  def index
    rate = Rate.current
    respond_to do |format|
      format.html
      if rate
        format.json { render json: rate, status: :ok }
      else
        format.json { render json: nil, status: :not_found }
      end
    end
  end
end
