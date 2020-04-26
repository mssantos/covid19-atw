defmodule Covid19Web.PageLive do
  require Logger

  use Covid19Web, :live_view

  @update_interval (Mix.env() == :dev && 20_000) || 10 * 60 * 1_000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(@update_interval, self(), :update)

    {:ok, assign(socket, results: fetch_results())}
  end

  @impl true
  def handle_info(:update, socket) do
    Logger.info("Preparing update...")
    {:noreply, assign(socket, :results, fetch_results())}
  end

  defp fetch_results, do: Covid19.list_all(:by_country)
end
