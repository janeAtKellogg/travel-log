class PlacesController < ApplicationController
  def index
    @places = Place.all.order({ "name" => "asc" })
    render({ :template => "places/index" })
  end

  def show
    @place = Place.find(params["id"])
    @entries = Entry.where({ "place_id" => @place["id"] }).order({ "occurred_on" => "asc" })
    render({ :template => "places/show" })
  end
end
