# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  describe 'index' do
    it 'shows a list of short urls' do
      Url.create(original_url: "https://github.com/titusfortner/webdrivers", short_url: "YHPIW", clicks_count: 6)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/23", short_url: "YHPIA", clicks_count: 5)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/asd", short_url: "YHPAA", clicks_count: 7)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/23d", short_url: "AAPIW", clicks_count: 9)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/wer", short_url: "ABPIW", clicks_count: 12)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/23es", short_url: "YCDIW", clicks_count: 3)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/23w", short_url: "YHPIN", clicks_count: 7)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/sd", short_url: "YHPIF", clicks_count: 8)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/we", short_url: "YHACW", clicks_count: 2)
      Url.create(original_url: "https://github.com/titusfortner/webdrivers/abc", short_url: "YHPEE", clicks_count: 0)
      visit root_path
      page = Url.last(10).reverse
      expect(page).to match page
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      url = create(:url)
      visit url_path(url.shor_url) # Put shor_url which is exist in DB     
      page.should have_content(url.original_url)
      page.should have_content(url.shor_url)
      page.should have_content(url.clicks_count)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('NOTFOUND')
        # expect page to be a 404
      end
    end
  end

  describe 'create' do
    context 'when url is valid' do
      it 'creates the short url' do
        visit '/'
        # add more expections
      end

      it 'redirects to the home page' do
        visit '/'
        # add more expections
      end
    end

    context 'when url is invalid' do
      it 'does not create the short url and shows a message' do
        visit '/'
        # add more expections
      end

      it 'redirects to the home page' do
        visit '/'
        # add more expections
      end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      visit visit_path('ABCDE')
      # add more expections
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')
        # expect page to be a 404
      end
    end
  end
end
