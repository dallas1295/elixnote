defmodule ElixnoteTest do
  use ExUnit.Case
  doctest Elixnote

  test "greets the world" do
    assert Elixnote.hello() == :world
  end
end
