defmodule Minimix.Generator do

  @lowercase_alphabetic Enum.to_list(?a..?z)

  def url() do
    data = {
      non_empty_segments(1, 2),
      non_empty_segments(1, 5),
      alpha(2, 3)
    }

    StreamData.map(data, fn {authority, path, domain} ->
      %URI{
        authority: "#{Enum.join(authority, ".")}.#{domain}",
        path: Path.join("/", Path.join(path)),
        scheme: "https"
      } |> to_string()
    end)
  end

  def non_empty_segments(min, max) do
    non_empty_string =
      StreamData.string(@lowercase_alphabetic)
      |> StreamData.filter(fn string -> string != "" end)

    StreamData.uniq_list_of(non_empty_string, min_length: min, max_length: max)
  end

  def alpha(min, max) do
    StreamData.map(StreamData.term(), fn _ ->
      range = Enum.random([min, max])
      ?a..?z |> Enum.to_list() |> Enum.shuffle |> Enum.take(range) |> List.to_string()
    end)
  end

end
