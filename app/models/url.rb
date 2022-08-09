class Url < ApplicationRecord
  has_many :clicks
  
  validates :original_url, presence: true, uniqueness: true
  validates :short_url, presence: true, uniqueness: true
  validates_format_of :original_url, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/, on: :create


  def as_json(opts = {})
    data = super(
      only: [:id],
      methods: [:type]
    )
    data.merge!(attributes: other_attributes, relationships: url_clicks)
  end

  def url_clicks
    selected_clicks = self.clicks.flat_map {|c| {type: c.type, id: c.id} }
    final_hash = selected_clicks.flat_map {|f| find_url_click(f)}
    {
      clicks: {
        data: final_hash 
      }
    }
  end

  def find_url_click(click)
    c = Click.find_by_id click[:id] 
    other_click_attributes = c.other_attributes #{url_id: c[:url_id], platform: c[:platform], browser: c[:browser], created_at: c[:created_at]}
    all_url_clicks = click.merge!(attributes: other_click_attributes)
    all_url_clicks
  end

  def type
    self.class.name.downcase.pluralize
  end

  def other_attributes
    {original_url: self.original_url, short_url: self.make_url+"/"+self.short_url, clicks: clicks_count, short_path: self.short_url, created_at: self.created_at}
  end
    
  def find_duplicate
    Url.find_by(original_url: self.original_url)
  end

  def new_url?
    find_duplicate.nil?
  end

  def make_url
    uri = parse_url
    uri.scheme+"://"+uri.host
  end

  def path_for_original_url
    uri = parse_url
    "#{uri.path.length > 30 ? uri.path[0,30]+"..." : uri.path}"
  end

  def parse_url
    URI.parse(self.original_url)
  end

end
