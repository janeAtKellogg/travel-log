require "test_helper"

class PlacesPageTest < ActionDispatch::IntegrationTest
  test "The places page lists each place with its name." do
    Place.create({ "name" => "Lisbon" })
    Place.create({ "name" => "Kyoto" })

    get("/places")

    assert_select("li", { :text => "Lisbon" })
    assert_select("li", { :text => "Kyoto" })
  end

  test "Each place name is a link to that place's page." do
    place = Place.create({ "name" => "Lisbon" })

    get("/places")

    assert_select("a[href='/places/#{place["id"]}']", { :text => "Lisbon" })
  end

  test "The user can visit /places and see every saved place in the database." do
    Place.create({ "name" => "Lisbon" })
    Place.create({ "name" => "Kyoto" })
    Place.create({ "name" => "Nairobi" })

    get("/places")

    assert_response(:success)
    assert_select("li", { :count => Place.count })
    Place.all.each do |place|
      assert_select("li", { :text => place["name"] })
    end
  end
end

class PlaceShowPageTest < ActionDispatch::IntegrationTest
  test "The place page shows the place's name." do
    place = Place.create({ "name" => "Lisbon" })

    get("/places/#{place["id"]}")

    assert_response(:success)
    assert_select("h1", { :text => "Lisbon" })
  end

  test "The place page lists each entry at that place with its title, date and description." do
    place = Place.create({ "name" => "Lisbon" })
    Entry.create({ "title" => "Tram 28 at sunrise", "occurred_on" => "2026-03-14", "description" => "Rode the yellow tram.", "place_id" => place["id"] })

    get("/places/#{place["id"]}")

    assert_select("li h2", { :text => "Tram 28 at sunrise" })
    assert_select("li p", { :text => "2026-03-14" })
    assert_select("li p", { :text => "Rode the yellow tram." })
  end

  test "Entries from other places do not appear." do
    lisbon = Place.create({ "name" => "Lisbon" })
    kyoto = Place.create({ "name" => "Kyoto" })
    Entry.create({ "title" => "Fushimi Inari", "occurred_on" => "2025-11-02", "place_id" => kyoto["id"] })

    get("/places/#{lisbon["id"]}")

    assert_select("h2", { :text => "Fushimi Inari", :count => 0 })
  end

  test "Entries are listed oldest first." do
    place = Place.create({ "name" => "Lisbon" })
    Entry.create({ "title" => "Second day", "occurred_on" => "2026-03-15", "place_id" => place["id"] })
    Entry.create({ "title" => "First day", "occurred_on" => "2026-03-14", "place_id" => place["id"] })

    get("/places/#{place["id"]}")

    titles = css_select("li h2").map { |heading| heading.text }
    assert_equal(["First day", "Second day"], titles)
  end

  test "A place with no entries says so." do
    place = Place.create({ "name" => "Door County" })

    get("/places/#{place["id"]}")

    assert_select("p", { :text => "No entries yet." })
  end

  test "The place page links back to the list of places." do
    place = Place.create({ "name" => "Lisbon" })

    get("/places/#{place["id"]}")

    assert_select("a[href='/places']")
  end
end
