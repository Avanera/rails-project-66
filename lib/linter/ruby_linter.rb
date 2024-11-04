# frozen_string_literal: true

module Linter
  class RubyLinter
    def initialize(repo_path, repository, check)
      @repo_path = repo_path
      @repository = repository
      @check = check
    end

    def run
      stdout, = Open3.capture3("rubocop --config=.rubocop.yml --format json #{@repo_path}")
      offenses = parse_rubocop_offenses(stdout)
      @check.update(passed: offenses.empty?, result: offenses.to_json)
    end

    private

    def parse_rubocop_offenses(stdout)
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
        cop_name: offense['cop_name'],
        line_and_column: "#{location['start_line']}:#{location['start_column']}",
        file_link: generate_file_link(file_path, location)
      }
    end

    def generate_file_link(file_path, location)
      base_url = @repository.clone_url.gsub('.git', '')
      "#{base_url}/tree/#{@check.commit_id}/#{file_path}#L#{location['start_line']}"
    end
  end
end
