defmodule Minimix do

  def shorter_url(url) do
    short_url = "https://mini.mix/" <> id()
    Minimix.Store.put(short_url, url)
    short_url
  end

  @keys ?a..?z |> Enum.to_list()

  defp id(max \\ 5) do
    @keys
    |> Enum.shuffle()
    |> Enum.take(max)
    |> List.to_string()
  end

end
