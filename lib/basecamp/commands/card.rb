# frozen_string_literal: true

module Basecamp
  module Commands
    class Card
      def run(project_id, card_id, comments: false)
        client = Client.new

        card = client.get("/buckets/#{project_id}/card_tables/cards/#{card_id}.json")

        puts "Card: #{card['title']}"
        puts "=" * 70
        puts ""
        puts "ID:       #{card['id']}"
        puts "Creator:  #{card.dig('creator', 'name')}"
        puts "Created:  #{card['created_at']}"
        puts "Updated:  #{card['updated_at']}"
        puts "URL:      #{card['app_url']}"

        if card['assignees'] && !card['assignees'].empty?
          names = card['assignees'].map { |a| a['name'] }.join(', ')
          puts "Assigned: #{names}"
        end

        puts ""
        puts "Description:"
        puts "-" * 40
        description = strip_html(card['content'] || card['description'] || 'No description')
        puts description
        puts ""

        if comments && card['comments_count']&.positive?
          puts "Comments (#{card['comments_count']}):"
          puts "-" * 40

          all_comments = client.get_all(card['comments_url'])

          all_comments.each do |comment|
            author = comment.dig('creator', 'name') || 'Unknown'
            content = strip_html(comment['content'] || '')
            created = comment['created_at']

            puts ""
            puts "#{author} (#{created}):"
            puts content
          end
        end
      end

      private

      def strip_html(html)
        return '' unless html
        html.gsub(/<[^>]*>/, ' ').gsub(/\s+/, ' ').strip
      end
    end
  end
end
