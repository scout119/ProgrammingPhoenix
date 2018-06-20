defmodule Rumbl.Accounts.UserTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Accounts.User

  @valid_attrs %{name: "A User", username: "r2d2"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)

    refute changeset.valid?
  end

  test "changeset does not accept long usernames" do
    attrs = Map.put(@valid_attrs, :username, String.duplicate("a",30))
    changeset = User.changeset(%User{}, attrs)
    assert "should be at most 20 character(s)" in errors_on(changeset).username
  end

  test "registration_changeset email is required" do
    attrs = Map.put(@valid_attrs, :credential, %{password: "darksite"})
    changeset = User.registration_changeset(%User{}, attrs)

    assert "can't be blank" in errors_on(changeset).credential.email
  end

  test "registration_changeset password must be at least 6 chars long" do
    attrs = Map.put(@valid_attrs, :credential, %{email: "r2d2@starwars.com", password: "12345"})
    changeset = User.registration_changeset(%User{}, attrs)

    assert "should be at least 6 character(s)" in errors_on(changeset).credential.password
  end

  test "registration_changeset with valid attributes hashes password" do
    attrs = Map.put(@valid_attrs, :credential, %{email: "r2d2@starwars.com", password: "darksite"})
    changeset = User.registration_changeset(%User{}, attrs)
    %{password: _pass, password_hash: _pass_hash} = changeset.changes.credential.changes

    assert changeset.valid?
  end
end
