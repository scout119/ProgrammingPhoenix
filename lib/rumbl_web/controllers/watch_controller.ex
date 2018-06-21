defmodule RumblWeb.WatchController do
  use RumblWeb, :controller

  def show(conn, %{"id" => id}) do
    video = Rumbl.Multimedia.get_video!(id)
    render conn, "show.html", video: video
  end

end
