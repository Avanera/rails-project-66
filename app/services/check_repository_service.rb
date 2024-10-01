# frozen_string_literal: true

class CheckRepositoryService
  MAX_ATTEMPTS = 5
  SLEEP_INTERVAL = 0.5

  def initialize(repository, check)
    @repository = repository
    @check = check
    @repo_path = "tmp/repos/#{@repository.name}/"
  end

  def run
    perform_checks
  rescue StandardError => e
    handle_failure(e)
  ensure
    remove_tmp_directory
  end

  private

  def perform_checks
    clone_repo_to_tmp
    assign_check_commit_id
    @check.start!
    run_rubocop
    @check.finish!
  end

  def clone_repo_to_tmp
    remove_tmp_directory if Dir.exist?(@repo_path)
    command_str = "git clone #{@repository.clone_url} #{@repo_path}"

    Open3.popen3(command_str) do |_, stdout, stderr, wait_thr|
      Rails.logger.info("Starting git clone from #{@repository.clone_url} to #{@repo_path}")
      Rails.logger.info(stdout.read)
      Rails.logger.error(stderr.read)
      Rails.logger.info("Exit status: #{wait_thr.value.exitstatus}")
    end
    validate_directory_presence
  end

  def validate_directory_presence
    MAX_ATTEMPTS.times do
      return if Dir.exist?(@repo_path)

      sleep SLEEP_INTERVAL
    end
    raise StandardError, t('services.check_repo.errors.directory_not_found', repo_path: @repo_path)
  end

  def assign_check_commit_id
    stdout, stderr, status = Open3.capture3("cd #{@repo_path}; git rev-parse --short HEAD")
    if status.success?
      @check.commit_id = stdout.strip
    else
      log_commit_error(stderr)
    end
  end

  def log_commit_error(stderr)
    @check.fail!
    Rails.logger.error(t('services.check_repo.errors.failed_to_get_commit_id',
                         stderr: stderr.strip))
  end

  def run_rubocop
    stdout, = Open3.capture3("rubocop --config=.rubocop.yml --format json #{@repo_path}")
    offenses = parse_rubocop_offenses(stdout)

    @check.update(passed: offenses.empty?, result: offenses.to_json)
  end

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

  def handle_failure(error)
    @check.fail!
    Rails.logger.error(error.message)
  end

  def remove_tmp_directory
    FileUtils.rm_rf(@repo_path)
  end
end
