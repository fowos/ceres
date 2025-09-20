defmodule CeresWeb.Router do
  use CeresWeb, :router

  import CeresWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CeresWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end


  pipeline :api do
    plug :accepts, ["json"]

  end

  scope "/", CeresWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", CeresWeb do
    pipe_through :api

    get "/image/*key", Api.Images.ImageController, :download

    get "/titles/:name", Api.Titles.TitlesController, :show

    get "/comics/:name", Api.Comics.ComicsController, :index
    get "/comics", Api.Comics.ComicsController, :index
    post "/comics", Api.Comics.ComicsController, :by_params


    get "/pages/:id", Api.Pages.PagesController, :index

    get "/tags", Api.Tags.TagsController, :index

    post "/chapters/upload", Api.Comics.ComicsController, :upload
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ceres, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CeresWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", CeresWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{CeresWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email

      live "/titles", TitlesList.TitlesListLive, :index
      live "/titles/new", TitlesList.Form, :new
      live "/titles/:id/edit", TitlesList.Form, :edit

      live "/comics", Comics.ComicsList, :index
      live "/comics/new", Comics.FormNew, :new
      live "/comics/new/:id", Comics.FormNew, :new
      live "/comics/:id/edit", Comics.FormEdit, :edit

      live "/chapters/comic/:id", Chapters.ChaptersHome, :index
      live "/chapters/new/:id", Chapters.ChaptersNew, :new
      live "/chapters/:id", Chapters.ChapterView, :index


      live "/tags", Tags.TagsView, :index
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/api", CeresWeb do
    pipe_through :api
    # TODO: auth for api, Phoenix.Token

    get "/titles/:name", Api.Titles.TitlesController, :show
    put "/titles", Api.Titles.TitlesController, :create
  end

  scope "/", CeresWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{CeresWeb.UserAuth, :mount_current_scope}] do
      # live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
