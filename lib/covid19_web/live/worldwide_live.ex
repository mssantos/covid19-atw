defmodule Covid19Web.WorldwideLive do
  require Logger

  use Covid19Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Covid19.subscribe("store")

    socket = socket
      |> assign(:results, fetch_data(:worldwide))
      |> assign(:summary, fetch_data(:summary))
      |> assign(:sort_by, "")
      |> assign(:query, "")

    {:ok, socket}
  end

  def handle_info({:store_updated, :worldwide}, socket) do
    socket = socket
      |> assign(:results, Covid19.sort_by(fetch_data(:worldwide), socket.assigns.sort_by))
      |> assign(:summary, fetch_data(:summary))
      |> assign(:query, "")

    {:noreply, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  def handle_event("sort_by", %{"sort_by" => sort_by}, socket) do
    ordered = Covid19.sort_by(socket.assigns.results, sort_by)

    socket = socket
      |> assign(:results, ordered)
      |> assign(:sort_by, sort_by)

    {:noreply, socket}
  end

  def handle_event("search", %{"query" => query}, socket) do
    query = String.trim(query)

    socket =
      socket
      |> assign(:results, Covid19.search(fetch_data(:worldwide), query))
      |> assign(:query, query)

    {:noreply, socket}
  end

  defp fetch_data(context), do: Covid19.get_data(context)
end
