defmodule Covid19 do
  @moduledoc """
  Covid19 keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def list_all(:by_country) do
    {:ok, result} = Covid19.Server.lookup(:by_country)
    result
  end

  def subscribe, do: Phoenix.PubSub.subscribe(Covid19.PubSub, "covid19")

  def broadcast(event),
    do: Phoenix.PubSub.broadcast(Covid19.PubSub, "covid19", {event, list_all(:by_country)})
end
