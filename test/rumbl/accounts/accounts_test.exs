defmodule Rumbl.AccountsTest do
  use Rumbl.DataCase

  #alias Rumbl.Accounts.User

  @valid_attrs %{name: "A User", username: "r2d2"}

  test "converts unique_constraint on username to error" do
    insert_user(%{username: "eric"})
    attrs = Map.put(@valid_attrs, :username, "eric")

    assert { :error, changeset } = Rumbl.Accounts.create_user(attrs)
    assert "has already been taken" in errors_on(changeset).username
  end
end
