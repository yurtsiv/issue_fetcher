defmodule IssueFetcher.CLITest do
  use ExUnit.Case
  import IssueFetcher.CLI, only: [parse_args: 1, sort_ascending: 1, convert_to_list_of_maps: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "something"]) === :help
    assert parse_args(["--help", "something"]) === :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "34"]) == {"user", "project", 34}
  end

  test "count is default when not specified" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort ascending by created_at" do
    result =
      fake_created_at_list(["a", "b", "c"])
      |> sort_ascending

    issues = for issue <- result, do: issue["created_at"]

    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    data = for value <- values, do: [{"created_at", value}, {"other_data", "..."}]
    convert_to_list_of_maps(data)
  end
end
