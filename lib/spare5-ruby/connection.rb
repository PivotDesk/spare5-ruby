require 'net/http'
require 'json'

module Spare5
  class Connection
    class << self
      attr_accessor :api_username, :api_token, :use_ssl
      attr_reader :base_url

      def base_url=(base_url)
        @base_url = base_url
        use_ssl = @base_url.start_with?('https')
      end
    end

    def self.get(path, params = nil)
      self.send_request(:get, false, path, params)
    end

    def self.post(path, params = nil)
      self.send_request(:post, false, path, params)
    end

    def self.get!(path, params = nil)
      self.send_request(:get, true, path, params)
    end

    def self.post!(path, params = nil)
      self.send_request(:post, true, path, params)
    end

    def self.send_request(method, raise_on_error, path, params)
      url = URI.parse("#{base_url}#{path}")
      case method
        when :post
          req = Net::HTTP::Post.new(url.request_uri)
          req.body = params.to_json
        when :get
          url.query = URI.encode_www_form(params) if params
          req = Net::HTTP::Get.new(url.request_uri)
      end

      req['User-Agent'] = "Spare5-ruby"
      req.basic_auth(api_username, api_token)
      req.content_type = 'application/json'

      http = Net::HTTP.new(url.hostname, url.port)
      http.use_ssl = true if use_ssl

      response = http.start.request(req)
      http_code = response.code.to_i
      body = response.body

      if !http_code.between?(200, 299)
        if raise_on_error
          raise "error code #{http_code}. Message: '#{body}'"
        else
          return nil
        end
      elsif !body || body.empty?
        return {}
      else
        return JSON::parse(body)
      end
    end

    def self.to_s
      [:api_username, :api_token, :use_ssl, :base_url].map { |key| Connection.send(key) }.to_s
    end
  end
end
