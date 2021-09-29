require "application_system_test_case"

class TripsTest < ApplicationSystemTestCase
  setup do
    @trip = trips(:one)
  end

  test "visiting the index" do
    visit trips_url
    assert_selector "h1", text: "Trips"
  end

  test "creating a Trip" do
    visit trips_url
    click_on "New Trip"

    fill_in "City", with: @trip.city
    fill_in "Country", with: @trip.country
    fill_in "Description", with: @trip.description
    fill_in "Finish on", with: @trip.finish_on
    check "Flexible" if @trip.flexible
    check "Goal" if @trip.goal
    fill_in "Start on", with: @trip.start_on
    fill_in "Title", with: @trip.title
    fill_in "User", with: @trip.user_id
    click_on "Create Trip"

    assert_text "Trip was successfully created"
    click_on "Back"
  end

  test "updating a Trip" do
    visit trips_url
    click_on "Edit", match: :first

    fill_in "City", with: @trip.city
    fill_in "Country", with: @trip.country
    fill_in "Description", with: @trip.description
    fill_in "Finish on", with: @trip.finish_on
    check "Flexible" if @trip.flexible
    check "Goal" if @trip.goal
    fill_in "Start on", with: @trip.start_on
    fill_in "Title", with: @trip.title
    fill_in "User", with: @trip.user_id
    click_on "Update Trip"

    assert_text "Trip was successfully updated"
    click_on "Back"
  end

  test "destroying a Trip" do
    visit trips_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Trip was successfully destroyed"
  end
end
