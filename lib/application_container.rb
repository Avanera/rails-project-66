# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  register(:octokit_client) do
    if Rails.env.test?
      OctokitClientStub
    else
      Octokit::Client
    end
  end

  register(:open3) do
    if Rails.env.test?
      Open3Stub.new
    else
      Open3
    end
  end
end
