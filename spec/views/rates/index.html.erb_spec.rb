require 'rails_helper'

RSpec.describe "rates/index.html.erb", type: :view do
  it 'display rate' do
    assign(:rate, value: 20.0, date: Date.today)
    render
    expect(rendered).to have_css('h2#rate', text: 20.0)
    expect(rendered).to have_css('span#date', text: Date.today)
  end
end
