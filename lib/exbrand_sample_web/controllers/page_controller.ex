defmodule ExbrandSampleWeb.PageController do
  use ExbrandSampleWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
