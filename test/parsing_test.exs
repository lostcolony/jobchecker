defmodule ParsingTest do
  use ExUnit.Case
  doctest Parsing

  test "filter works as an or" do
    assert Parsing.filter([{"abc", "blah"}, {"bca", "tah"}, {"tad", "hadha"}], [~r/ab/, ~r/ca/]) == [{"abc", "blah"}, {"bca", "tah"}]
  end

  test "filter supports ignoring case" do
    assert Parsing.filter([{"ABC", "blah"}, {"BCA", "tah"}, {"tad", "hadha"}], [~r/ab/i, ~r/ca/i]) == [{"ABC", "blah"}, {"BCA", "tah"}]
  end

  test "filter supports wildcards" do
    assert Parsing.filter([{"Software Engineering Manager", "blah"}], [~r/engineer[[:print:]]+manage/i]) == [{"Software Engineering Manager", "blah"}]
  end
end
