# frozen_string_literal: true

module Basecamp
  module Commands
    class Cards
      def run(project_id, board_id, column: nil)
        client = Client.new

        # Get the card table
        card_table = client.get("/buckets/#{project_id}/card_tables/#{board_id}.json")

        puts "Cards: #{card_table['title']}"
        puts "=" * 70

        lists = card_table['lists'] || []

        if lists.empty?
          puts "No columns found."
          return
        end

        lists.each do |list|
          column_name = list['title']

          # Filter by column if specified
          if column
            next unless column_name.downcase.include?(column.downcase)
          end

          next if list['cards_count'].zero?

          puts ""
          puts "#{column_name} (#{list['cards_count']})"
          puts "-" * 40

          # Fetch cards from this column
          cards = client.get(list['cards_url'])

          cards.each do |card|
            creator = card.dig('creator', 'name') || 'Unknown'
            puts "  #{card['id']}  #{card['title']}"
            puts "           by #{creator}"
          end
        end
      end
    end
  end
end
