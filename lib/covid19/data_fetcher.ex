defmodule Covid19.DataFetcher do
  use GenServer

  require Jason
  require Logger

  alias Covid19.Store

  @fetch_data_interval (Mix.env() == :dev && 10_000) || 5 * 60 * 1_000
  @apify_endpoint 'https://api.apify.com/v2/key-value-stores/tVaYRsPHLjNdNBu7S/records/LATEST?disableRedirect=true'

  # Client

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # Server

  @impl true
  def init(_state) do
    store =
      Store.create([
        {:all, []},
        {:by_country, []},
        {:summary, %{}}
      ])

    send(self(), :fetch_data)
    {:ok, store}
  end

  @impl true
  def handle_info(:fetch_data, state) do
    Logger.info("Fetching data...")

    case :httpc.request(@apify_endpoint) do
      {:ok, {_status, _headers, body}} ->
        Logger.info("Data fetched.")

        decoded_body = Jason.decode!(body)
        Store.update(:all, decoded_body)
        Store.update_summary(decoded_body)
        schedule_fetch()

        {:noreply, state}

      {:error, reason} ->
        Logger.debug(reason)
        {:noreply, state}
    end
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, _reason}, {names, refs}) do
    {:noreply, {names, refs}}
  end

  defp schedule_fetch do
    Process.send_after(self(), :fetch_data, @fetch_data_interval)
  end
end
