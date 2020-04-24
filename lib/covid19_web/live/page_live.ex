defmodule Covid19Web.PageLive do
  use Covid19Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Covid19.subscribe()

    {:ok, assign(socket, results: fetch_results())}
  end

  @impl true
  def handle_info({:fetched_data, results}, socket),
    do: {:noreply, update(socket, :results, fn _old -> results end)}

  defp fetch_results, do: Covid19.list_all(:by_country)
end
