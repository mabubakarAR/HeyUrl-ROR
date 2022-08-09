class UrlsController < ApplicationController
  before_action :set_browser, only: :create_click
  before_action :new_url, only: :index

  # Recent 10 short urls in descending order
  def index
    @urls = Url.last(10).reverse
  end

  
  # desc      Get 10 last urls according to required response
  # route     GET {{url}}/url_list  e.g http://localhost:3000/url_list
  # access    Public
  def url_list
    @urls = Url.last(10).reverse
    @all_clicks = Click.all.reverse
    render :json => {message: "Urls found successfully", success: true, data: @urls.as_json, included: @all_clicks.as_json}
  end

  # Create short URL by giving the Original URL
  def create
    begin
      original_url = params[:url][:original_url]

      # Create Short URL
      url = shortened_url(original_url) if original_url.present?
      
      # Checking duplicates
      if url.new_url? 
        if url.save
          message = "Url created successfully"
          response_message(message)
        else
          message = "URL Is Invalid. Please enter a valid URL"
          response_message(message)
        end
      else
        message = "Short link for this URL is already in database"
        response_message(message)
      end
    rescue => exception
      nil_msg = "URL cannot be empty"
      message = original_url.blank? ? nil_msg : exception.message
      response_message(message)
    end

  end

  # Click Analytics Queries
  def show
    @url = Url.find_by_short_url params[:url]

    # Fetched Daily Clicks
    create_at = "extract(day from created_at)"
    day_hash = Click.select("#{create_at} as date").group("#{create_at}").count("#{create_at}")
    daily_clicks = Hash[ day_hash.keys.map(&:to_i).zip(day_hash.values) ]
    @daily_clicks = daily_clicks.to_a

    # Fetched Browser Clicks
    @browsers_clicks = Click.group(:browser).count(:browser).to_a

    # Fetched Pltform Clicks
    @platform_clicks = Click.group(:platform).count(:platform).to_a
  end

  # AJAX called API to save clicks on click Short URL
  def create_click
    url = Url.find_by_original_url params['url']
    @url_clicks = url.clicks.new(browser: @browser.name, platform: @browser.platform.name)
    if @url_clicks.save
      url_clicks = url.clicks.count
      url.update_attributes(clicks_count: url_clicks)
    end
  end

  # Check whether Short URL is valid If it is invalid, render to 404 Page
  def visit
    url = Url.find_by_short_url params[:short_url]
    if url.present?
      path_to_be_directed = url.original_url
      redirect_to path_to_be_directed
    else
      render_404
    end

  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  private

  def response_message(msg)
    respond_to do |format|
      format.html {
        flash[:notice] = msg
        redirect_to root_url
      }
    end
  end

  def new_url
    @url = Url.new
  end

  def set_browser
    @browser ||= Browser.new(
      request.headers["User-Agent"],
      accept_language: request.headers["Accept-Language"]
    )
  end

  def shortened_url(url)
    short_url_length = 5

    # Generating path for short url which covers all checks
    short_url_path = ([*('A'..'Z')]).sample(short_url_length).join
    
    Url.new(original_url: url, short_url: short_url_path)
  end

end