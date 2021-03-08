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
  def shorter_url(url) do
    short_url = @prefix <> id()
    Minimix.Store.put(short_url, url)
    short_url
  end

  @doc """
  Takes in a valid url returning a mnemonized url.
  """
  @spec contextual_shorter_url(url :: String.t()) :: String.t()
  requires url?(url), "Given string should be a valid url: #{url}"
  ensures match?(<<@prefix, _ :: binary>>, result), "Given string should match prefix: #{@prefix}"
  def contextual_shorter_url(url) do
    uri = URI.parse(url)
    host = if(uri.host, do: uri.host, else: "") |> String.replace("www", "") |> String.replace(".", "-")
    path = if(uri.path, do: uri.path, else: "") |> shorten_url_path()
    short_url = Path.join([@prefix, host, path, id(3)])

    Minimix.Store.put(short_url, url)
    short_url
  end

  @spec shorten_url_path(word :: String.t()) :: String.t()
  ensures String.length(path) >= String.length(result)
  defp shorten_url_path(path) do
    path
    |> String.split("/")
    |> Enum.map(&shorten_segment/1)
    |> Path.join("/")
  end

  defp shorten_segment(segment), do: shorten_segment(segment, String.length(segment))

  defp shorten_segment(segment, length) when length <= 5, do: segment
  defp shorten_segment(segment, length) when length > 5 and length < 10, do: replace_vowels(segment)
  defp shorten_segment(_segment, length) when length >= 10, do: ""

  @vowels ~w(a e i o u)

  @spec replace_vowels(word :: String.t()) :: String.t()
  ensures result |> String.printable?(), "Result has non-printable characters"
  ensures result |> String.codepoints() |> Enum.all?(fn x -> x not in @vowels end), "#{result} contains vowels #{@vowels}"
  defp replace_vowels(word) do
    String.replace(word, @vowels, "")
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
