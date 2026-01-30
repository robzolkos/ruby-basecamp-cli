# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'openssl'

module Basecamp
  class Client
    USER_AGENT = 'Basecamp CLI (https://github.com/rzolkos/basecamp-cli)'

    def initialize
      @token = Config.token
    end

    def get(path)
      url = path.start_with?('http') ? path : "#{Config.api_base_url}#{path}"
      request(:get, url)
    end

    def post(path, data = {})
      url = path.start_with?('http') ? path : "#{Config.api_base_url}#{path}"
      request(:post, url, data)
    end

    def put(path, data = {})
      url = path.start_with?('http') ? path : "#{Config.api_base_url}#{path}"
      request(:put, url, data)
    end

    # Fetch all pages of a paginated endpoint
    def get_all(path)
      results = []
      url = path.start_with?('http') ? path : "#{Config.api_base_url}#{path}"

      loop do
        response = request_raw(:get, url)
        results.concat(JSON.parse(response.body))

        # Check for next page
        link_header = response['Link']
        break unless link_header

        next_link = link_header.split(',').find { |l| l.include?('rel="next"') }
        break unless next_link

        url = next_link.match(/<([^>]+)>/)[1]
      end

      results
    end

    private

    def request(method, url, data = nil)
      response = request_raw(method, url, data)
      return nil if response.body.nil? || response.body.empty?
      JSON.parse(response.body)
    end

    def request_raw(method, url, data = nil)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      request = case method
                when :get then Net::HTTP::Get.new(uri.request_uri)
                when :post then Net::HTTP::Post.new(uri.request_uri)
                when :put then Net::HTTP::Put.new(uri.request_uri)
                end

      request['Authorization'] = "Bearer #{@token}"
      request['User-Agent'] = USER_AGENT
      request['Content-Type'] = 'application/json' if data

      request.body = data.to_json if data

      response = http.request(request)

      unless response.is_a?(Net::HTTPSuccess)
        raise "API error: #{response.code} #{response.message}\n#{response.body}"
      end

      response
    end
  end
end
