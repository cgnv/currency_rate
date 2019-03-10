# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rates/index.html.erb', type: :view do
  it 'display previous rate' do
    assign(:rate, Rate.new(value: 60.0, expired_at: Time.now))
    render
    expect(rendered).to have_css('input[type="number"][value="60.0"]')
  end
end
