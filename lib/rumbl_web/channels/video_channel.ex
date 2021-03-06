defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  alias RumblWeb.AnnotationView

  import Ecto;
  import Ecto.Query;


  def join("videos:" <> video_id, params, socket) do

    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Rumbl.Multimedia.get_video!(video_id)

    # annotations =
    #   video
    #   |> Rumbl.Multimedia.list_annotations()

    annotations = Rumbl.Repo.all(
      from a in assoc(video, :annotations),
      where: a.id > ^last_seen_id,
      order_by: [asc: a.at, asc: a.id],
      limit: 200,
      preload: [:user]
    )

    resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}

    {:ok, resp, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Rumbl.Accounts.get_user(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    changeset =
      user
      |> build_assoc(:annotations, video_id: socket.assigns.video_id)
      #|> Rumbl.Multimedia.create_annotation(params)
      |> Rumbl.Multimedia.Annotation.changeset(params)

    case Rumbl.Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast_annotation(socket, annotation)
        Task.start_link( fn -> compute_additional_info(annotation,socket) end)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_annotation(socket, annotation) do
    annotation = Rumbl.Repo.preload(annotation, :user)
    rendered_ann = Phoenix.View.render(AnnotationView, "annotation.json", %{
      annotation: annotation
    })
    broadcast!(socket, "new_annotation", rendered_ann)
  end

  defp compute_additional_info(annotation, socket) do
    for result <- Rumbl.InfoSys.compute(annotation.body, limit: 1, timeout: 10000) do
      attrs = %{url: result.url, body: result.text, at: annotation.at}
      info_changeset =
        Rumbl.Repo.get_by!(Rumbl.Accounts.User, username: result.backend)
        |> build_assoc(:annotations, video_id: annotation.video_id)
        |> Rumbl.Multimedia.Annotation.changeset(attrs)
      case Rumbl.Repo.insert(info_changeset) do
        {:ok, info_ann} -> broadcast_annotation(socket, info_ann)
        {:error, _changeset} -> :ignore
      end
    end
  end
end
