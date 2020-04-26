defmodule Covid19.Server do
  use GenServer

  require Jason
  require Logger

  @fetch_data_interval (Mix.env() == :dev && 10_000) || 5 * 60 * 1_000
  @apify_endpoint 'https://api.apify.com/v2/key-value-stores/tVaYRsPHLjNdNBu7S/records/LATEST?disableRedirect=true'
  @bucket :bucket

  # Client

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def lookup(name) do
    case :ets.lookup(@bucket, name) do
      [{^name, data}] -> {:ok, data}
      [] -> :error
    end
  end

  # Server

  @impl true
  def init(_state) do
    bucket = :ets.new(@bucket, [:set, :protected, :named_table])
    :ets.insert(@bucket, {:by_country, []})

    send(self(), :fetch_data)

    {:ok, bucket}
  end

  @impl true
  def handle_info(:fetch_data, state) do
    Logger.info("Fetching data...")

    case :httpc.request(@apify_endpoint) do
      {:ok, {_status, _headers, body}} ->
        Logger.info("Data fetched.")
        schedule_fetch()

        {:noreply, :ets.insert(@bucket, {:by_country, Jason.decode!(body)})}

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
