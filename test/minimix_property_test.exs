defmodule MinimixPropertyTest do
  use ExUnit.Case
  use ExUnitProperties

  describe "url?/1" do

    property "predicate and model work together" do
      check all url <- Minimix.Generator.url() do
        assert Minimix.url?(url)
      end
    end

  end

  describe "shorter_url/1" do

    property "works as expected" do
      check all url <- Minimix.Generator.url() do
        assert Minimix.shorter_url(url)
      end
    end

  end

  describe "contextual_shorter_url/1" do

    property "works as expected" do
      check all url <- Minimix.Generator.url() do
        IO.inspect(url)
        assert Minimix.contextual_shorter_url(url)
      end
    end

  end
end
