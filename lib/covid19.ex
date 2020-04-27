defmodule Covid19 do
  @moduledoc """
  Covid19 keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_data(context) do
    {:ok, result} = Covid19.Store.lookup(context)
    result
  end

  def subscribe(topic),
    do: Phoenix.PubSub.subscribe(Covid19.PubSub, topic)

  def broadcast(topic, message),
    do: Phoenix.PubSub.broadcast(Covid19.PubSub, topic, message)
end
