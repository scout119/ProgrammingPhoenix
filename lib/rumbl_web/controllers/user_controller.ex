defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  plug :authenticate_user when action in [:index, :show]

  alias Rumbl.Accounts  

  def index(conn, _params) do
      users = Accounts.list_users()
      render(conn, "index.html", users: users)            
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end  

  def new(conn, _params) do
    changeset = Accounts.change_user()
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do      
      {:ok, user } ->
        conn
          |> Rumbl.Auth.login(user)
          |> put_flash(:info, "#{user.name} created!")
          |> redirect(to: user_path(conn, :show, user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end    
  end  
end