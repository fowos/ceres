defmodule CeresWeb.PageController do
  use CeresWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
