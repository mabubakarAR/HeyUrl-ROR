class Click < ApplicationRecord
  belongs_to :url

  validates :browser, presence: true
  validates :platform, presence: true
  validates :url_id, presence: true

  def as_json
    data = super(
      only: [:id],
      methods: [:type]
    )
    data.merge!(attributes: other_attributes)
  end

  def type
    self.class.name.downcase.pluralize
  end

  def other_attributes
    {url_id: self.url_id, platform: self.platform, browser: self.browser, created_at: self.created_at}
  end
end
