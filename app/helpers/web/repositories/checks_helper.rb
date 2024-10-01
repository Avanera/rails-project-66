# frozen_string_literal: true

module Web::Repositories::ChecksHelper
  def human_attribute_name_passed(check)
    Repository::Check.human_attribute_name("passed/#{check.passed}")
  end

  def github_commit_url(repository, check)
    "#{repository.clone_url.delete_suffix('.git')}/commit/#{check.commit_id}"
  end
end
