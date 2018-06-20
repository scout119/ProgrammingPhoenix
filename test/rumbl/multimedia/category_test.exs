defmodule Rumbl.Multimedia.CategoryTest do
  use Rumbl.DataCase

  alias Rumbl.Multimedia.Category

  test "alphabetical/1 orders by name" do
    Rumbl.Multimedia.create_category(%{name: "c"})
    Rumbl.Multimedia.create_category(%{name: "a"})
    Rumbl.Multimedia.create_category(%{name: "b"})

    query = Category |> Category.alphabetical()
    query = from c in query, select: c.name
    #Change this to use the context module
    assert Rumbl.Repo.all(query) == ~w(a b c)
  end
end
