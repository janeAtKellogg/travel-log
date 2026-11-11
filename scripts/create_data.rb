Place.destroy_all
Entry.destroy_all

# Create places. Each one is somewhere I've been.

lisbon = Place.new
lisbon["name"] = "Lisbon"
lisbon.save

kyoto = Place.new
kyoto["name"] = "Kyoto"
kyoto.save

door_county = Place.new
door_county["name"] = "Door County"
door_county.save

# Create entries. Each one is something that happened, on the day it happened.

entry = Entry.new
entry["title"] = "Tram 28 at sunrise"
entry["description"] = "Rode the yellow tram from end to end before the crowds. Got off at Graca for coffee and a view of the river."
entry["occurred_on"] = "2026-03-14"
entry["place_id"] = lisbon.id
entry.save

entry = Entry.new
entry["title"] = "Grilled sardines in Alfama"
entry["description"] = "Dinner on a staircase, six sardines, a plate of bread and a lot of lemon. The restaurant had four tables."
entry["occurred_on"] = "2026-03-15"
entry["place_id"] = lisbon.id
entry.save

entry = Entry.new
entry["title"] = "Fushimi Inari before breakfast"
entry["description"] = "Walked the torii gates up the mountain at 6 am. Nearly nobody else, and the light came through orange."
entry["occurred_on"] = "2025-11-02"
entry["place_id"] = kyoto.id
entry.save

entry = Entry.new
entry["title"] = "Nishiki Market lunch"
entry["description"] = "Ate my way down the market: tamagoyaki on a stick, pickles, a matcha soft serve. Bought a knife I did not need."
entry["occurred_on"] = "2025-11-03"
entry["place_id"] = kyoto.id
entry.save

entry = Entry.new
entry["title"] = "Fish boil at the harbor"
entry["description"] = "Watched them throw kerosene on the fire to boil it over. Whitefish, potatoes, onions, cherry pie after."
entry["occurred_on"] = "2026-07-18"
entry["place_id"] = door_county.id
entry.save

puts "There are now #{Place.all.count} places and #{Entry.all.count} entries."
