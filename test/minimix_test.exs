defmodule MinimixTest do
  use ExUnit.Case
  doctest Minimix

  describe "shorter_url/1" do

    test "shortens the url" do
      url = "https://parana.pe/es/product/B48G3M73CDCW087MMW5C76TMJTAKLG"
      short_url = Minimix.shorter_url(url)

      assert String.length(url) > String.length(short_url)
    end

  end

end
