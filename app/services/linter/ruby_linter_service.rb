# frozen_string_literal: true

module Linter
  class RubyLinterService < LinterService
    private

    def linter_command
      "rubocop --config=.rubocop.yml --format json #{@repo_path}"
    end

    def parse_offenses(stdout)
      JSON.parse(stdout)['files'].flat_map do |file|
        file_path = file['path'].sub(@repo_path, '')
        file['offenses'].map do |offense|
          format_offense(file_path, offense)
        end
      end
    end

    def format_offense(file_path, offense)
      location = offense['location']
      {
        path: file_path,
        message: offense['message'],
        rule_id: offense['cop_name'],
        coords: "#{location['start_line']}:#{location['start_column']}",
        github_url: generate_github_url(file_path, location['start_line'])
      }
    end
  end
end
