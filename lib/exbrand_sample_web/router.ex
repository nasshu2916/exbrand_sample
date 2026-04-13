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
    get "/users", UserPageController, :index
    get "/users/new", UserPageController, :new
    post "/users", UserPageController, :create
    get "/users/:user_id", UserPageController, :show
    get "/users/:user_id/edit", UserPageController, :edit
    put "/users/:user_id", UserPageController, :update
    patch "/users/:user_id", UserPageController, :update
    delete "/users/:user_id", UserPageController, :delete
  end

  scope "/api", ExbrandSampleWeb do
    pipe_through :api

    get "/users", UserController, :index
    get "/users/:user_id", UserController, :show
    post "/users", UserController, :create
    put "/users/:user_id", UserController, :update
    patch "/users/:user_id", UserController, :update
    delete "/users/:user_id", UserController, :delete
  end
end
