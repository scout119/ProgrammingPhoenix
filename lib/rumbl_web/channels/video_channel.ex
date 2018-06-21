defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> _video_id, _params, socket) do
    #:timer.send_interval(5_000, :ping)
    #{:ok, assign(socket, :video_id, String.to_integer(video_id))}
    {:ok, socket}
  end

  # def handle_info(:ping, socket) do
  #   count = socket.assigns[:count] || 1
  #   push socket, "ping", %{count: count}

  #   {:noreply, assign(socket, :count, count + 1)}
  # end

  def handle_in("new_annotation", params, socket) do
    %{username: username } = Rumbl.Accounts.get_user(socket.assigns[:user_id])
    broadcast! socket, "new_annotation", %{
      user: %{username: username},
      body: params["body"],
      at: params["at"]
    }

    {:reply, :ok, socket}
  end
end
