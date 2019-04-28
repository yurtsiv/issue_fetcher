defmodule IssueFetcher.GitHubIssues do
  @user_agent [{"User-agent", "Elixir yurtsiv.stepan@gmail.com"}]

  def fetch(user, project) do
    get_url(user, project)
    |> HTTPoison.get(@user_agent)
  end

  defp get_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end
end