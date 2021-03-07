defmodule Minimix do
  @moduledoc """
  Minimix is a url shortener, current design goals are:

  * Should accept a long url
  * Should return a "shorter" url
  """

  use ExContract

  @prefix "https://mini.mix/"

  @doc """
  Takes in a valid url returning its equivalent short url.
  """
  @spec shorter_url(url :: String.t()) :: String.t()
  requires url?(url), "Given string should be a valid url: #{url}"
  ensures match?(<<@prefix, _ :: binary-size(5)>>, result), "Given string should match prefix: #{@prefix}"
  ensures String.length(url) > String.length(result), "Generated url should be shorter: \n\turl:\t#{url} \n\tresult:\t#{result}"
  def shorter_url(url) do
    short_url = @prefix <> id()
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
