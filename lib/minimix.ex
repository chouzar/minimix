defmodule Minimix do
  @moduledoc """
  Minimix is a url shortener, current design goals are:

  * Should accept a long url
  * Should return a "shorter" url
  """

  use ExContract

  @doc """
  Takes in a valid url returning its equivalent short url.
  """
  @spec shorter_url(url :: String.t()) :: String.t()
  def shorter_url(url) do
    short_url = "https://mini.mix/" <> id()
    Minimix.Store.put(short_url, url)
    short_url
  end

  @keys ?a..?z |> Enum.to_list()

  @spec id(integer()) :: String.t()
  defp id(max \\ 5) do
    @keys
    |> Enum.shuffle()
    |> Enum.take(max)
    |> List.to_string()
  end

  @spec url?(String.t()) :: boolean()
  def url?(url) do
    case URI.parse url do
      %{host: nil} -> false
      %{port: nil} -> false
      %{scheme: nil} -> false
      %{} -> true
    end
  end

end
