# frozen_string_literal: true

class Open3Stub
  GIT_CLONE_COMMAND_KEY_WORD = 'git clone'
  GIT_REV_PARSE_COMMAND_KEY_WORD = 'git rev-parse'
  ESLINT_COMMAND_KEY_WORD = 'eslint'
  RUBOCOP_COMMAND_KEY_WORD = 'rubocop'

  def initialize(*); end

  def capture3(cmd)
    stdout = build_stdout(cmd)
    stderr = StringIO.new('fake error if any')
    wait_thr = build_wait_thread

    yield(nil, stdout, stderr, wait_thr) if block_given?

    [stdout, stderr, wait_thr]
  end

  private

  # rubocop:disable Metrics/MethodLength
  def build_stdout(cmd)
    if cmd.include?(GIT_CLONE_COMMAND_KEY_WORD)
      StringIO.new('')
    elsif cmd.include?(GIT_REV_PARSE_COMMAND_KEY_WORD)
      'fake_commit_id'
    elsif cmd.include?(ESLINT_COMMAND_KEY_WORD)
      [].to_json
    elsif cmd.include?(RUBOCOP_COMMAND_KEY_WORD)
      File.read('test/fixtures/files/fake_rubocop_output_without_offenses.json')
    else
      raise "Unexpected command: #{cmd}"
    end
  end
  # rubocop:enable Metrics/MethodLength

  def build_wait_thread
    wait_thr = OpenStruct.new(value: OpenStruct.new(exitstatus: 0)) # rubocop:disable Style/OpenStructUse
    wait_thr.define_singleton_method(:success?) { value.exitstatus.zero? }
    wait_thr
  end
end
