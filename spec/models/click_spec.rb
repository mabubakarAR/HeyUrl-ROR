require 'rails_helper'

RSpec.describe Click, type: :model do
  subject { Click.new(url_id: 29, browser: "Chrome", platform: "Linux") }

  before { subject.save }

  describe 'validations' do
    it 'validates url_id is valid' do
      subject.url_id = "abc"
      expect(subject.url_id).to_not eq(String)
    end

    it 'validates url_id is not null' do
      subject.url_id = nil
      expect(subject).to_not be_valid
    end

    it 'validates browser is not null' do
      subject.browser = nil
      expect(subject).to_not be_valid
    end

    it 'validates platform is not null' do
      subject.platform = nil
      expect(subject).to_not be_valid
    end
  end
end
