defmodule Covid19Web.WorldwideLive do
  require Logger

  use Covid19Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Covid19.subscribe("store")

    {:ok, assign(socket, results: fetch_data(:worldwide), summary: fetch_data(:summary))}
  end

  @impl true
  def handle_info({:store_updated, :worldwide}, socket) do
    {:noreply, assign(socket, results: fetch_data(:worldwide), summary: fetch_data(:summary))}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  defp fetch_data(context), do: Covid19.get_data(context)
end
