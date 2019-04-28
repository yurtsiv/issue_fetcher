defmodule IssueFetcher.CLI do
  import IssueFetcher.TableFormatter

  @default_count 4

  @moduledoc """
  Handle the command line parsing
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it's a GitHub user name, project name and
  number of entries to show (optional)

  Returns a tuple of `{user, project, count}`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse =
      OptionParser.parse(
        argv,
        switches: [help: :boolean],
        aliases: [h: :help]
      )

    case parse do
      {[help: true], _, _} ->
        :help

      {_, [user, project, count], _} ->
        {user, project, String.to_integer(count)}

      {_, [user, project], _} ->
        {user, project, @default_count}

      _ ->
        :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issue_fetcher <user> <project> [count | #{@default_count}]
    """
    
    System.halt(0)
  end

  def process({user, project, count}) do
    IssueFetcher.GitHubIssues.fetch(user, project) 
    |> decode_response
    |> convert_to_list_of_maps
    |> sort_ascending
    |> Enum.take(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts "Error fetching from GitHub: #{error}"

    # System.halt(0)
  end

  def convert_to_list_of_maps(list) do
    list
    |> Enum.map(&Enum.into(&1, Map.new))
  end

  def sort_ascending(list) do
    Enum.sort(
      list,
      fn e1, e2 -> e1["created_at"] <= e2["created_at"] end
    ) 
  end
end
