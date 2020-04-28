defmodule Covid19.Store do
  @store_name :store

  def create(initial_state) do
    store = :ets.new(@store_name, [:set, :protected, :named_table])
    :ets.insert(store, initial_state)
    store
  end

  def lookup(name) do
    case :ets.lookup(@store_name, name) do
      [{^name, data}] ->
        {:ok, data}

      reason ->
        {:error, reason}
    end
  end

  def update(result) do
    do_update({:summary, aggregate(result)})
    do_update({:worldwide, take(result)})
    Covid19.broadcast("store", {:store_updated, :worldwide})
  end

  def update(context, result) do
    do_update({context, result})
    Covid19.broadcast("store", {:store_updated, context})
  end

  defp do_update(data) do
    :ets.insert(@store_name, data)
  end

  defp aggregate(data) do
    %{
      "infected" => aggregate_by(data, "infected"),
      "tested" => aggregate_by(data, "tested"),
      "recovered" => aggregate_by(data, "recovered"),
      "deceased" => aggregate_by(data, "deceased")
    }
  end

  defp aggregate_by(data, key) do
    Enum.reduce(data, 0, fn item, acc ->
      case value = item[key] do
        v when is_integer(value) ->
          v + acc

        _ ->
          acc
      end
    end)
  end

  defp take(data) do
    Enum.map(data, &(Map.take(&1, ["country", "infected", "tested", "recovered", "deceased", "moreData"])))
  end
end
