# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin::Rate create', type: :system do
  before { driven_by(:rack_test) }
  before { Rails.cache.delete('admin_rate') }
  let(:time) { Time.now.tomorrow.strftime('%d.%m.%Y %H:%M') }

  it 'doesnt create invalid rate' do
    visit 'admin/rates'
    click_button 'Создать Курс'
    expect(page).to have_text('сохранение не удалось из-за 3 ошибок')
  end

  it 'create valid rate' do
    visit 'admin/rates'
    fill_in 'rate_value', with: 2.3456
    fill_in 'rate_expire_at', with: time
    click_button 'Создать Курс'
    expect(page).to have_text('Курс изменен')
    expect(page).to have_css('input[type="number"][value="2.3456"]')
    expect(page).to have_css('input[type="datetime-local"]')
  end

  it 'show create rate insted official rate' do
    visit 'admin/rates'
    fill_in 'rate_value', with: 2.3456
    fill_in 'rate_expire_at', with: time
    click_button 'Создать Курс'
    visit 'rates'
    expect(page).to have_text('2.3456')
  end
end
