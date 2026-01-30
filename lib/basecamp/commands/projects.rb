# frozen_string_literal: true

module Basecamp
  module Commands
    class Projects
      def run
        client = Client.new
        projects = client.get('/projects.json')

        if projects.empty?
          puts "No projects found."
          return
        end

        puts "Projects"
        puts "=" * 60

        projects.each do |project|
          status = project['status']
          status_icon = status == 'active' ? '*' : ' '

          puts "[#{status_icon}] #{project['id']}  #{project['name']}"
          puts "    #{project['description']}" if project['description'] && !project['description'].empty?
        end

        puts ""
        puts "[*] = active"
      end
    end
  end
end
