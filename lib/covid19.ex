defmodule Covid19 do
  @moduledoc """
  Covid19 keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def list_all do
    {:ok, result} = Covid19.Store.lookup(:all)
    result
  end

  def aggregate(data) do
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
end
