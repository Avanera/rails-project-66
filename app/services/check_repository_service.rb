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
    run_linter
    @check.finish!

    send_check_offenses_email unless @check.passed
  end

  def run_linter
    linter_class = "Linter::#{@repository.language&.capitalize || 'Ruby'}LinterService".constantize
    linter_class.new(@repo_path, @repository, @check).run
  end

  def clone_repo_to_tmp
    remove_tmp_directory if Dir.exist?(@repo_path)
    command_str = "git clone #{@repository.clone_url} #{@repo_path}"
    ApplicationContainer[:open3].capture3(command_str) do |_, stdout, stderr, wait_thr|
      Rails.logger.info("Starting git clone from #{@repository.clone_url} to #{@repo_path}")
      Rails.logger.info(stdout.read)
      Rails.logger.error(stderr.read)
      Rails.logger.info("Exit status: #{wait_thr.value.exitstatus}")
    end
    validate_directory_presence
  end

  def validate_directory_presence
    MAX_ATTEMPTS.times do
      return if ApplicationContainer[:dir].exist?(@repo_path)

      sleep SLEEP_INTERVAL
    end
    raise StandardError,
          I18n.t('services.check_repo.errors.directory_not_found', repo_path: @repo_path)
  end

  def assign_check_commit_id
    cmd = "cd #{@repo_path}; git rev-parse --short HEAD"
    stdout, stderr, status = ApplicationContainer[:open3].capture3(cmd)
    if status.success?
      @check.commit_id = stdout.strip
    else
      log_commit_error(stderr)
    end
  end

  def log_commit_error(stderr)
    @check.fail!
    Rails.logger.error(I18n.t('services.check_repo.errors.failed_to_get_commit_id',
                              stderr: stderr.strip))
  end

  def handle_failure(error)
    @check.fail!
    Rails.logger.debug @repository
    Rails.logger.error(error.message)
    CheckMailer.with(
      check: @check,
      repository: @repository
    ).check_error_email.deliver_later
  end

  def remove_tmp_directory
    FileUtils.rm_rf(@repo_path)
  end

  def send_check_offenses_email
    CheckMailer.with(
      check: @check,
      repository: @repository
    ).check_offenses_email.deliver_later
  end
end
