class LivingSocial
  require 'open-uri'
  require 'mechanize'

  def self.select_unique_links(page)
    page.uniq{ |x| x.uri }
  end

  def self.element?(element)
    element ? true : false
  end

  def self.is_adventure?(page)
    page.root.at_css('div.deal-title')
  end

  def self.fetch_adventures(page)
    adventures_index = select_unique_links page.links_with(:href => %r{/adventures/})
    adventures_index = adventures_index.select { |a| a.text != 'see our team' }
    dummy = []
    adventures_index.each do |adventure|
      adventure_page = adventure.click
      dummy << parse(adventure_page) if is_adventure?(adventure_page)
    end
    dummy
  end

  def self.parse(page)
    title = page.root.css(".deal-title h1").text.split(" - ").first.strip
    puts title
    image_url = page.root.at_css('.slide img').attribute('src').value()
    buy_url = page.search('link').first.attr('href')
    city = page.root.css(".deal-title p").text.split(%r{\W{2,}})[-2]
    state = page.root.css(".deal-title p").text.split(",")[-1].strip
    price = page.root.css('.deal-price').text.split(%r{\D})[-1]
    description = page.root.at_css('.description').text
    lat_long = page.root.css('.directions a').map { |link| link['href'] }.join("").split("=")[-1]
    unless lat_long == "http://maps.google.com/maps?q"
      latitude = lat_long.split(",")[0].strip
      longitude = lat_long.split(",")[1].strip
    end
    details = page.root.css('.highlights ul li').text.gsub("\n","--")
    market = page.at('.deal-description')['data-market']

    sold_out = element?(page.root.at_css('div.sold-out'))
    expiration = page.root.css('.fine-print p').text.split(%r{\b[A-Z]+\b}).last.strip
    zipcode = page.root.xpath("//br/following-sibling::text()").text.split(" ").last
    params = {title: title, sold_out: sold_out, city: city, state: state,
                  zipcode: zipcode,
                  description: description,
                  latitude: latitude,
                  longitude: longitude,
                  details: details,
                  market: market,
                  price: price,
                  image_url: image_url,
                  buy_url: buy_url}
  end

  def self.save_to_db(adventures)
    puts adventures.first.inspect
    adventures.each do |params|
      db_market = Market.find_or_create_by_city params[:market]
      db_market.latitude = params[:latitude]
      db_market.longitude = params[:longitude]
      db_market.save
      db_adventure = Adventure.find_or_initialize_by_title params[:title]
      db_adventure.details = params[:details]
      db_adventure.description = params[:description]
      db_adventure.price = params[:price]
      db_adventure.market_id = db_market.id
      db_adventure.city = params[:city]
      db_adventure.state = params[:state]
      db_adventure.image_url = params[:image_url]
      db_adventure.buy_url = params[:buy_url]
      db_adventure.zipcode = params[:zipcode]
      db_adventure.sold_out = params[:sold_out]
      db_adventure.latitude = params[:latitude]
      db_adventure.longitude = params[:longitude]
      db_adventure.save
    end
  end

  def self.create_market(market)

  end

  def self.fetch_all
    agent = Mechanize.new
    adventure_home = agent.get('http://livingsocial.com/adventures')
    adventure_indexes = fetch_index_links adventure_home

    current_index = adventure_home
    adventures_list = []
    
    7.times do |i|
      puts "new page"
      adventures_list << fetch_adventures(current_index)
      next_link = current_index.link_with(:text => "Next")
      current_index = next_link.click if next_link 
    end

    save_to_db(adventures_list.flatten)
  end

  def self.fetch_index_links(page)
    select_unique_links page.links_with(:href => %r{page})
  end

  def self.at_home_deals(entries)
    entries.select do |entry|
      entry.search('deal_type').first.text == "Adventures"
    end
  end
end

namespace :livingsocial do
  task :get_adventures => :environment do
    LivingSocial.fetch_all
  end
end