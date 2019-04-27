defmodule IssueFetcher.CLITest do
  use ExUnit.Case
  import IssueFetcher.CLI, only: [ parse_args: 1 ]

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
end