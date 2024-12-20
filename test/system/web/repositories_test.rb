# frozen_string_literal: true

require 'application_system_test_case'

module Web
  class RepositoriesTest < ApplicationSystemTestCase
    setup do
      @repository = repositories(:javascript)
    end

    test 'visiting the index' do
      visit repositories_url
      assert_selector 'h1', text: 'Repositories'
    end

    test 'should create repository' do
      visit repositories_url
      click_on 'New repository'

      fill_in 'Clone url', with: @repository.clone_url
      fill_in 'Full name', with: @repository.full_name
      fill_in 'Github', with: @repository.github_id
      fill_in 'Language', with: @repository.language
      fill_in 'Name', with: @repository.name
      fill_in 'Ssh url', with: @repository.ssh_url
      fill_in 'User', with: @repository.user_id
      click_on 'Create Repository'

      assert_text 'Repository was successfully created'
      click_on 'Back'
    end

    test 'should update Repository' do
      visit repository_url(@repository)
      click_on 'Edit this repository', match: :first

      fill_in 'Clone url', with: @repository.clone_url
      fill_in 'Full name', with: @repository.full_name
      fill_in 'Github', with: @repository.github_id
      fill_in 'Language', with: @repository.language
      fill_in 'Name', with: @repository.name
      fill_in 'Ssh url', with: @repository.ssh_url
      fill_in 'User', with: @repository.user_id
      click_on 'Update Repository'

      assert_text 'Repository was successfully updated'
      click_on 'Back'
    end

    test 'should destroy Repository' do
      visit repository_url(@repository)
      click_on 'Destroy this repository', match: :first

      assert_text 'Repository was successfully destroyed'
    end
  end
end
