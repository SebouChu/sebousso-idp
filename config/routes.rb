Rails.application.routes.draw do
  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
end
