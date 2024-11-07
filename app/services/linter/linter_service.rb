# frozen_string_literal: true

module Linter
  class LinterService
    def initialize(repo_path, repository, check)
      @repo_path = repo_path
      @repository = repository
      @check = check
    end

    def run
      stdout, = ApplicationContainer[:open3].capture3(linter_command)
      offenses = parse_offenses(stdout).compact
      @check.update(passed: offenses.empty?)
      @check.offenses.create(offenses) if offenses.any?
    end

    private

    def linter_command
      raise NotImplementedError, 'Subclasses must define a linter_command'
    end

    def parse_offenses(stdout)
      raise NotImplementedError, 'Subclasses must define parse_offenses'
    end

    def generate_github_url(file_path, line)
      base_url = @repository.clone_url.gsub('.git', '')
      "#{base_url}/tree/#{@check.commit_id}/#{file_path}#L#{line}"
    end
  end
end
