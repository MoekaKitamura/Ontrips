require "application_system_test_case"

class ProfilesTest < ApplicationSystemTestCase
  setup do
    @profile = profiles(:one)
  end

  test "visiting the index" do
    visit profiles_url
    assert_selector "h1", text: "Profiles"
  end

  test "creating a Profile" do
    visit profiles_url
    click_on "New Profile"

    fill_in "Birthday", with: @profile.birthday
    fill_in "First language", with: @profile.first_language
    fill_in "Gender", with: @profile.gender
    fill_in "Home city", with: @profile.home_city
    fill_in "Home country", with: @profile.home_country
    fill_in "Icon", with: @profile.icon
    fill_in "Introduction", with: @profile.introduction
    fill_in "Second language", with: @profile.second_language
    fill_in "User", with: @profile.user_id
    click_on "Create Profile"

    assert_text "Profile was successfully created"
    click_on "Back"
  end

  test "updating a Profile" do
    visit profiles_url
    click_on "Edit", match: :first

    fill_in "Birthday", with: @profile.birthday
    fill_in "First language", with: @profile.first_language
    fill_in "Gender", with: @profile.gender
    fill_in "Home city", with: @profile.home_city
    fill_in "Home country", with: @profile.home_country
    fill_in "Icon", with: @profile.icon
    fill_in "Introduction", with: @profile.introduction
    fill_in "Second language", with: @profile.second_language
    fill_in "User", with: @profile.user_id
    click_on "Update Profile"

    assert_text "Profile was successfully updated"
    click_on "Back"
  end

  test "destroying a Profile" do
    visit profiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Profile was successfully destroyed"
  end
end
