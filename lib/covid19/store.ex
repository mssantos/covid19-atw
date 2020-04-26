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

  def update(data) do
    :ets.insert(@store_name, data)
  end
end
