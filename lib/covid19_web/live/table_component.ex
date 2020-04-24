defmodule Covid19Web.PageLive.TableEntryComponent do
  use Covid19Web, :live_component

  def render(%{entry: entry} = assigns) do
    ~L"""
    <tr>
      <td><%= entry["country"] %></td>
      <td><%= entry["infected"] || "-" %></td>
      <td><%= entry["tested"] || "-" %></td>
      <td><%= entry["recovered"] || "-" %></td>
      <td><%= entry["deceased"] || "-" %></td>
    </tr>
    """
  end
end
