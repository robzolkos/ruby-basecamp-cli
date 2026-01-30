# frozen_string_literal: true

module Basecamp
  module Commands
    class Boards
      def run(project_id)
        client = Client.new

        # Get project details to find the card table dock
        project = client.get("/projects/#{project_id}.json")

        puts "Card Tables in: #{project['name']}"
        puts "=" * 60

        # Find card tables in the dock
        dock = project['dock'] || []
        card_table_dock = dock.find { |d| d['name'] == 'kanban_board' }

        unless card_table_dock
          puts "No card table found in this project."
          return
        end

        # Get the card table
        card_table_url = card_table_dock['url']
        card_table = client.get(card_table_url)

        puts "#{card_table['id']}  #{card_table['title']}"

        # Show columns summary
        lists = card_table['lists'] || []
        if lists.any?
          puts ""
          puts "Columns:"
          lists.each do |list|
            puts "  - #{list['title']} (#{list['cards_count']} cards)"
          end
        end
      end
    end
  end
end
