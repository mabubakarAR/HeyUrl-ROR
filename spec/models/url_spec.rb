require 'rails_helper'

RSpec.describe Url, type: :model do
  subject { Url.new(original_url: "https://mail.google.com/mail/u/0/#inbox", short_url: "https://mail.google.com/ABCDE", clicks_count: 10) }

  before { subject.save }

  describe 'validations' do
    
    #'validates original URL is a valid URL'
    before do
      subject.original_url = "http://thetheater.com/index.php"
    end
    it { should be_valid } 

    it 'validates short URL is present' do
      subject.short_url = nil
      expect(subject).to_not be_valid
    end

  end
end
