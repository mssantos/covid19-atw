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

  def get_summary do
    {:ok, result} = Covid19.Store.lookup(:summary)
    result
  end
end
