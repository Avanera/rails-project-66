# frozen_string_literal: true

module Linter
  class JavascriptLinter
    def initialize(repo_path, repository, check)
      @repo_path = repo_path
      @repository = repository
      @check = check
    end

    def run
      stdout, = Open3.capture3(
        "yarn --silent eslint -c lib/linter/configs/eslint.config.mjs -f json #{@repo_path}"
      )
      offenses = parse_es_lint_offenses(stdout)
      @check.update(passed: offenses.empty?, result: offenses.to_json)
    end

    private

    def parse_es_lint_offenses(stdout)
      JSON.parse(stdout).flat_map do |file|
        next if file['messages'].empty?

        file_path = file['filePath'].sub(/^.*?#{Regexp.escape(@repo_path)}/, '')
        file['messages'].map do |offense|
          format_es_lint_offense(file_path, offense)
        end
      end
    end

    def format_es_lint_offense(file_path, offense)
      {
        path: file_path,
        message: offense['message'],
        cop_name: offense['ruleId'],
        line_and_column: "#{offense['line']}:#{offense['column']}",
        file_link: generate_es_file_link(file_path, offense['line'])
      }
    end

    def generate_es_file_link(file_path, line)
      base_url = @repository.clone_url.gsub('.git', '')
      "#{base_url}/tree/#{@check.commit_id}/#{file_path}#L#{line}"
    end
  end
end
