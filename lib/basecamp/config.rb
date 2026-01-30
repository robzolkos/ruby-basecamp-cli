# frozen_string_literal: true

module Basecamp
  class Config
    CONFIG_FILE = File.expand_path('~/.basecamp.json')
    TOKEN_FILE = File.expand_path('~/.basecamp_token.json')

    # OAuth endpoints
    AUTHORIZATION_URL = 'https://launchpad.37signals.com/authorization/new'
    TOKEN_URL = 'https://launchpad.37signals.com/authorization/token'

    class << self
      def load
        return @config if @config

        unless File.exist?(CONFIG_FILE)
          raise "Config file not found: #{CONFIG_FILE}\nRun 'basecamp init' to create one."
        end

        @config = JSON.parse(File.read(CONFIG_FILE), symbolize_names: true)
      end

      def save(config)
        File.write(CONFIG_FILE, JSON.pretty_generate(config))
        @config = config
      end

      def client_id
        load[:client_id]
      end

      def client_secret
        load[:client_secret]
      end

      def account_id
        load[:account_id]
      end

      def redirect_uri
        load[:redirect_uri] || 'http://localhost:3002/callback'
      end

      def api_base_url
        "https://3.basecampapi.com/#{account_id}"
      end

      def token
        return @token if @token

        unless File.exist?(TOKEN_FILE)
          raise "Not authenticated. Run 'basecamp auth' first."
        end

        token_data = JSON.parse(File.read(TOKEN_FILE), symbolize_names: true)

        if token_data[:expires_at] && Time.now.to_i > token_data[:expires_at]
          raise "Token expired. Run 'basecamp auth' to refresh."
        end

        @token = token_data[:access_token]
      end

      def save_token(token_data)
        token_data[:expires_at] = Time.now.to_i + token_data[:expires_in] if token_data[:expires_in]
        File.write(TOKEN_FILE, JSON.pretty_generate(token_data))
        @token = token_data[:access_token]
      end

      def clear_token_cache
        @token = nil
      end
    end
  end
end
