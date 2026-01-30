# frozen_string_literal: true

require 'webrick'
require 'net/http'
require 'uri'
require 'json'
require 'openssl'

module Basecamp
  module Commands
    class Auth
      def run
        puts "Basecamp OAuth Authentication"
        puts "=" * 40

        @auth_code = nil
        start_server
        open_authorization_url
        wait_for_callback
        exchange_code_for_token

        puts "\nAuthentication successful!"
        puts "Token saved to: #{Config::TOKEN_FILE}"
      end

      private

      def start_server
        port = URI(Config.redirect_uri).port || 3002
        puts "\nStarting callback server on port #{port}..."

        @server = WEBrick::HTTPServer.new(
          Port: port,
          Logger: WEBrick::Log.new('/dev/null'),
          AccessLog: []
        )

        @server.mount_proc '/callback' do |req, res|
          @auth_code = req.query['code']

          res.status = 200
          res.content_type = 'text/html'
          res.body = if @auth_code
                       '<html><body style="font-family:sans-serif;text-align:center;padding:50px;">' \
                       '<h1>Authentication Successful!</h1><p>You can close this window.</p></body></html>'
                     else
                       '<html><body style="font-family:sans-serif;text-align:center;padding:50px;">' \
                       '<h1>Authentication Failed</h1><p>No authorization code received.</p></body></html>'
                     end
        end

        Thread.new { @server.start }
        sleep 0.5
      end

      def open_authorization_url
        params = URI.encode_www_form(
          type: 'web_server',
          client_id: Config.client_id,
          redirect_uri: Config.redirect_uri
        )
        auth_url = "#{Config::AUTHORIZATION_URL}?#{params}"

        puts "\nOpening browser for authorization..."
        puts "URL: #{auth_url}"
        puts "\nIf browser doesn't open, copy the URL above."

        system("xdg-open '#{auth_url}' 2>/dev/null || open '#{auth_url}' 2>/dev/null || true")
      end

      def wait_for_callback
        puts "\nWaiting for authorization..."

        timeout = 120
        start = Time.now

        until @auth_code
          sleep 0.5
          if Time.now - start > timeout
            @server.shutdown
            raise 'Timeout waiting for authorization'
          end
        end

        @server.shutdown
        puts "Authorization code received"
      end

      def exchange_code_for_token
        puts "\nExchanging code for token..."

        uri = URI(Config::TOKEN_URL)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data(
          type: 'web_server',
          client_id: Config.client_id,
          client_secret: Config.client_secret,
          redirect_uri: Config.redirect_uri,
          code: @auth_code
        )

        response = http.request(request)

        unless response.is_a?(Net::HTTPSuccess)
          raise "Token exchange failed: #{response.code} #{response.message}\n#{response.body}"
        end

        token_data = JSON.parse(response.body, symbolize_names: true)
        Config.save_token(token_data)
      end
    end
  end
end
