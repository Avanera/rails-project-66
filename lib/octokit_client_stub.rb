# frozen_string_literal: true

class OctokitClientStub
  Repo = Struct.new(:id, :name, :full_name, :language, :ssh_url, :clone_url)
  def initialize(*); end

  def repos(*)
    [
      Repo.new(123_456_789, 'aaa', 'owner/aaa', 'Ruby', 'git@github.com:owner/aaa.git', 'https://github.com/owner/aaa.git'),
      Repo.new(234_567_891, 'bbb', 'owner/bbb', 'Ruby', 'git@github.com:owner/bbb.git', 'https://github.com/owner/bbb.git'),
      Repo.new(345_678_912, 'ccc', 'owner/ccc', 'Go', 'git@github.com:owner/ccc.git', 'https://github.com/owner/ccc.git')
    ]
  end

  def repository(*)
    Repo.new(123_456_789, 'aaa', 'owner/aaa', 'Ruby', 'git@github.com:owner/aaa.git', 'https://github.com/owner/aaa.git')
  end
end
