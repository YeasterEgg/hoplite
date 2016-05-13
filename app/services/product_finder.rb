class ProductFinder

  CLASS_NAME = Product
  LOGFILE = 'product_finder.log'

  def initialize(product, logging = true, log = LOGFILE )
    logger = File.new(Rails.root.join('log',log), 'a') if logging
    right_now = Time.now
    logger.puts("#{right_now.strftime('%d/%m/%y')} - Somebody clicked on product #{product[:code]} @ #{right_now.strftime('%H:%M')}") if logging
    params = find_out_name(product,'http://www.decathlon.it', '/Comprare/', 'Prodotto Inattivo')
    product.update_attributes(name: params[:name], website: params[:website])
    if product[:name] == 'Prodotto Inattivo'
      logger.puts("Turns out this product is inactive, no name for him!") if logging
    else
      logger.puts("Turns out that the name of this product was -#{product[:name]}- all along! Who knew!") if logging
    end
    logger.puts("----    ----    ----    ----    ----    ----    ----    ----") if logging
    logger.close if logging
  end

  def self.nightshift(minutes = 15, log = LOGFILE)
    logger = File.new(Rails.root.join('log',log), 'a')
    logger.puts("#{Time.now.strftime('%d/%m/%y')} - STARTING ProductFinder Nightshift!")
    starting_time = Time.now
    finishing_time = starting_time + minutes.minutes
    logger.puts("There are #{CLASS_NAME.unnamed.size} names to find out of #{CLASS_NAME.all.size} products.")
    logger.puts("Started searching for names at: #{starting_time.strftime('%H:%M')}, will go on until #{finishing_time.strftime('%H:%M')}")
    names_found = 0
    inactive_products = 0
    while Time.now < finishing_time
      break if Product.unnamed.empty?
      product = Product.unnamed.sample
      ProductFinder.new(product, logging = false)
      if product[:name] == 'Prodotto Inattivo'
        inactive_products += 1
      else
        names_found += 1
      end
    end
    logger.puts("Well it's been a wonderful time, I've found #{names_found} names and #{inactive_products} inactive products, but there are still #{Product.unnamed.size} products without name...")
    logger.puts("----    ----    ----    ----    ----    ----    ----    ----")
    logger.close
  end

  private

    def find_out_name(product, website, website_path, placeholder_name)
      ## It works only with live products, also it's really unstable + product names SUCKS.
      ## That said, it's FUCKINGSLOW&dirty, still better than nothing
      product_url = URI(website + website_path + product[:code])
      response_to_url = Net::HTTP.get_response(product_url)
      if response_to_url['location']
        return {
                name: parse_product_title(response_to_url['location']),
                website: response_to_url['location'],
               }
      else
        return {
                name: placeholder_name,
                website: website,
               }
      end
    end

    def parse_product_title(title)
      ## I know, it's bad. There surely are better solutions, but I'm quite curious to test it, I will
      ## refactor later (as in never)
      title.split('-id_')[0].split('/')[-1].gsub('-',' ').capitalize.strip
    end

    def self.search_random_products(number)
      CLASS_NAME.unnamed.sample(number).each do |product|
        ProductFinder.new(product)
      end
    end
end
