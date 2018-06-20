defmodule Rumbl.TestHelpers do
  alias Rumbl.Repo

  def insert_user( attrs \\ %{}) do
    changes = Map.merge( %{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      credential: %{password: "supersecret", email: "some#{Base.encode16(:crypto.strong_rand_bytes(8))}@dot.com"}
    }, attrs)

    %Rumbl.Accounts.User {}
    |> Rumbl.Accounts.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_video(user, attrs \\%{}) do
    %Rumbl.Multimedia.Video{}
    |> Rumbl.Multimedia.Video.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    # user
    # |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!()
  end

end
