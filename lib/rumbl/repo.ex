# defmodule Rumbl.Repo do
#   @moduledoc """
#   In memory repository.
#   """
#   def all(Rumbl.User) do
#     [
#       %Rumbl.User{ id: "1", name: "Valentin", username: "vivanov", password: "elixr"},
#       %Rumbl.User{ id: "2", name: "Oxana", username: "oxanai", password: "vanila"},
#       %Rumbl.User{ id: "3", name: "Alex", username: "shura", password: "tennis"}
#     ]
#   end

#   def all(_module), do: []

#   def get(module, id) do
#     Enum.find all(module), fn map -> map.id == id end
#   end

#   def get_by(module, params) do
#     Enum.find all(module), fn map ->
#       Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end) 
#     end
#   end
# end

defmodule Rumbl.Repo do
  use Ecto.Repo, otp_app: :rumbl

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end  
end
