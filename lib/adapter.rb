module Magentwo
  class Adapter < Magentwo::Connection
    DateFields = %i(created_at dob  updated_at)
    def call method, path, params
      http_method, params = case method
      when :put, :post, :delete then [method, params.to_json]
      when :get, :get_with_meta_data then [:get, params]
      else
        raise ArgumentError, "unknown method type. Expected :get, :get_with_meta_data, :post, :put or :delete. #{method} #{path}"
      end

      response = self.send(http_method, path, params)

      parsed_response = case method
      when :get_with_meta_data, :put, :post, :delete then transform( parse( response))
      when :get
        parsed = parse(response)
        if parsed[:items]
          parsed[:items].map do |item|
            transform item
          end
        else
          transform parsed
        end
      else
        raise ArgumentError, "unknown method type. Expected :get, :get_with_meta_data, :post, :put or :delete. #{method} #{path}"
      end
    end

    private
    def parse response
      case response.code
      when "200"
        JSON.parse response.body, :symbolize_names => true
      else
        puts "request failed #{response.code} #{response.body}"
      end
    end

    def transform item
      date_transform item if item
    end

    def date_transform item
      p "datetransform: #{item}"
      DateFields.each do |date_field|
        item[date_field] = Time.new item[date_field] if item[date_field]
      end
      item
    end
  end
end