defmodule ExbrandSampleWeb.Router do
  use ExbrandSampleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExbrandSampleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExbrandSampleWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", ExbrandSampleWeb do
    pipe_through :api

    get "/users", UserController, :index
    post "/users", UserController, :create
  end
end
