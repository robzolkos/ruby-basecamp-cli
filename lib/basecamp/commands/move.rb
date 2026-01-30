# frozen_string_literal: true

module Basecamp
  module Commands
    class Move
      def run(project_id, board_id, card_id, to:)
        client = Client.new

        # Get the card table to find the target column
        card_table = client.get("/buckets/#{project_id}/card_tables/#{board_id}.json")

        lists = card_table['lists'] || []
        target_column = lists.find { |l| l['title'].downcase == to.downcase }

        unless target_column
          puts "Column '#{to}' not found."
          puts "Available columns: #{lists.map { |l| l['title'] }.join(', ')}"
          return
        end

        # Move the card
        client.post("/buckets/#{project_id}/card_tables/cards/#{card_id}/moves.json", {
          column_id: target_column['id']
        })

        puts "Card #{card_id} moved to '#{target_column['title']}'"
      end
    end
  end
end
