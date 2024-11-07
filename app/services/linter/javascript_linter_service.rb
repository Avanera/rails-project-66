# frozen_string_literal: true

module Linter
  class JavascriptLinterService < LinterService
    private

    def linter_command
      "yarn --silent eslint -c eslint.config.mjs -f json #{@repo_path}"
    end

    def parse_offenses(stdout)
      JSON.parse(stdout).flat_map do |file|
        next if file['messages'].empty?

        file_path = file['filePath'].sub(/^.*?#{Regexp.escape(@repo_path)}/, '')
        file['messages'].map do |offense|
          format_offense(file_path, offense)
        end
      end
    end

    def format_offense(file_path, offense)
      {
        path: file_path,
        message: offense['message'],
        rule_id: offense['ruleId'],
        coords: "#{offense['line']}:#{offense['column']}",
        github_url: generate_github_url(file_path, offense['line'])
      }
    end
  end
end
