Rails.application.routes.draw do
  get("/", { :controller => "home", :action => "index" })
  get("/data", { :controller => "data", :action => "show" })

  # Each resource gets one line here, which makes all seven of its routes:
  # index, show, new, create, edit, update, destroy. For example:
  # resources("companies")
  resources("places")
end
