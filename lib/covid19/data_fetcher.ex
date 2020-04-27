defmodule Covid19.DataFetcher do
  use GenServer

  require Jason
  require Logger

  alias Covid19.Store

  @fetch_intervals %{
    worldwide: 10 * 60 * 1_000
  }

  @apify_endpoints %{
    worldwide: 'https://api.apify.com/v2/key-value-stores/tVaYRsPHLjNdNBu7S/records/LATEST?disableRedirect=true'
  }

  # Client

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # Server

  @impl true
  def init(_state) do
    store = Store.create([
      {:worldwide, []},
      {:summary, %{}}
    ])

    send(self(), :fetch_worldwide)

    {:ok, store}
  end

  @impl true
  def handle_info(:fetch_worldwide, state) do
    case request(@apify_endpoints.worldwide) do
      {:ok, result} ->
        Store.update(result)        
        schedule_fetch(:worldwide)
        {:noreply, state}

      {:error, _reason} ->
        {:noreply, state}
    end
  end

  @impl true
  def handle_info(_message, state) do
    {:noreply, state}
  end

  defp schedule_fetch(:worldwide) do
    Process.send_after(self(), :fetch_worldwide, @fetch_intervals.worldwide)
  end

  defp request(endpoint) do
    Logger.info("Requesting data...")

    case :httpc.request(endpoint) do
      {:ok, {_status, _headers, body}} ->
        Logger.info("Data received.")
        {:ok, Jason.decode!(body)}

      {:error, reason} ->
        Logger.debug(reason)
        {:error, reason}
    end
  end
end
