defmodule IssueFetcher.GitHubIssues do
  @user_agent [{"User-agent", "yurtsiv yurtsiv.stepan@gmail.com"}]
  @github_url Application.get_env(:issue_fetcher, :github_url)

  def fetch(user, project) do
    get_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  defp get_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({
    :ok,
    %HTTPoison.Response{ status_code: 404 }
  }) do
    {:error, "Not found"}
  end

  defp handle_response({
    :ok,
    %HTTPoison.Response{ status_code: 200, body: body }
  }) do
    {:ok, :jsx.decode(body)}
  end

  defp handle_response({:error, error}) do
    {:error, error.reason}
  end
end