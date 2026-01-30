# frozen_string_literal: true

require 'json'
require_relative 'version'
require_relative 'config'
require_relative 'client'
require_relative 'commands/init'
require_relative 'commands/auth'
require_relative 'commands/projects'
require_relative 'commands/boards'
require_relative 'commands/cards'
require_relative 'commands/card'
require_relative 'commands/move'

module Basecamp
  class CLI
    HELP = <<~HELP
      Usage: basecamp <command> [options]

      Commands:
        init                              Configure the CLI (client_id, secret, account)
        auth                              Authenticate with Basecamp (OAuth)
        projects                          List all projects
        boards <project_id>               List card tables in a project
        cards <project_id> <board_id>     List cards (--column <name> to filter)
        card <project_id> <card_id>       Show card details (--comments for comments)
        move <project_id> <board_id> <card_id> --to <column>   Move a card
        version                           Show version

      Examples:
        basecamp projects
        basecamp boards 12345678
        basecamp cards 12345678 87654321 --column "Doing"
        basecamp card 12345678 11111111 --comments
        basecamp move 12345678 87654321 11111111 --to "Done"
    HELP

    def run(args)
      if args.empty? || args.first == 'help' || args.first == '--help' || args.first == '-h'
        puts HELP
        return
      end

      command = args.shift

      case command
      when 'version', '--version', '-v'
        puts "basecamp-cli #{VERSION}"
        return
      when 'init'
        Commands::Init.new.run
      when 'auth'
        Commands::Auth.new.run
      when 'projects'
        Commands::Projects.new.run
      when 'boards'
        project_id = args.shift or raise "Usage: basecamp boards <project_id>"
        Commands::Boards.new.run(project_id)
      when 'cards'
        project_id = args.shift or raise "Usage: basecamp cards <project_id> <board_id>"
        board_id = args.shift or raise "Usage: basecamp cards <project_id> <board_id>"
        column = extract_option(args, '--column')
        Commands::Cards.new.run(project_id, board_id, column: column)
      when 'card'
        project_id = args.shift or raise "Usage: basecamp card <project_id> <card_id>"
        card_id = args.shift or raise "Usage: basecamp card <project_id> <card_id>"
        comments = args.include?('--comments')
        Commands::Card.new.run(project_id, card_id, comments: comments)
      when 'move'
        project_id = args.shift or raise "Usage: basecamp move <project_id> <board_id> <card_id> --to <column>"
        board_id = args.shift or raise "Usage: basecamp move <project_id> <board_id> <card_id> --to <column>"
        card_id = args.shift or raise "Usage: basecamp move <project_id> <board_id> <card_id> --to <column>"
        to = extract_option(args, '--to') or raise "Usage: basecamp move ... --to <column>"
        Commands::Move.new.run(project_id, board_id, card_id, to: to)
      else
        puts "Unknown command: #{command}"
        puts HELP
        exit 1
      end
    rescue => e
      $stderr.puts "Error: #{e.message}"
      exit 1
    end

    private

    def extract_option(args, flag)
      idx = args.index(flag)
      return nil unless idx

      args.delete_at(idx)
      args.delete_at(idx)
    end
  end
end
