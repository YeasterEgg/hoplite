class ProductFinder

  def initialize(product)
    params = find_out_name(product)
    product.update_attributes(name: params[:name], website: params[:website])
  end

  private

    def find_out_name(product)
      ## It works only with live products, also it's really unstable + product names SUCKS.
      ## That said, it's FUCKINGSLOW&dirty, still better than nothing
      product_url = URI("http://www.decathlon.it/Comprare/#{product[:code]}")
      response_to_url = Net::HTTP.get_response(product_url)
      if response_to_url['location']
        return {
                name: parse_product_title(response_to_url['location']),
                website: response_to_url['location'],
               }
      else
        return {
                name: 'ProdottoInattivo',
                website: 'http:://www.decathlon.it',
               }
      end
    end

    def parse_product_title(title)
      ## I know, it's bad. There surely are better solutions, but I'm quite curious to test it, I will
      ## refactor later (as in never)
      title.split('-id_')[0].split('/')[-1].gsub('-',' ').capitalize
    end
end
