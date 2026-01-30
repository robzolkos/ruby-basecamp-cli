# frozen_string_literal: true

module Basecamp
  module Commands
    class Init
      def run(client_id: nil, client_secret: nil, account_id: nil, redirect_uri: nil)
        puts "Basecamp CLI Configuration"
        puts "=" * 40

        config = {}

        config[:client_id] = client_id || prompt("Client ID")
        config[:client_secret] = client_secret || prompt("Client Secret")
        config[:account_id] = account_id || prompt("Account ID")
        config[:redirect_uri] = redirect_uri || prompt("Redirect URI", default: "http://localhost:3002/callback")

        Config.save(config)

        puts "\nConfiguration saved to: #{Config::CONFIG_FILE}"
        puts "Run 'basecamp auth' to authenticate."
      end

      private

      def prompt(label, default: nil)
        if default
          print "#{label} [#{default}]: "
        else
          print "#{label}: "
        end

        value = $stdin.gets.chomp
        value.empty? ? default : value
      end
    end
  end
end
