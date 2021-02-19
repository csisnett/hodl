defmodule HodlWeb.RankingController do
  use HodlWeb, :controller

  alias Hodl.Portfolio
  alias Hodl.Portfolio.Ranking

  def index(conn, _params) do
    rankings = Portfolio.list_rankings()
    render(conn, "index.html", rankings: rankings)
  end

  def new(conn, _params) do
    changeset = Portfolio.change_ranking(%Ranking{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"ranking" => ranking_params}) do
    case Portfolio.create_ranking(ranking_params) do
      {:ok, ranking} ->
        conn
        |> put_flash(:info, "Ranking created successfully.")
        |> redirect(to: Routes.ranking_path(conn, :show, ranking))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ranking = Portfolio.get_ranking!(id)
    render(conn, "show.html", ranking: ranking)
  end

  def edit(conn, %{"id" => id}) do
    ranking = Portfolio.get_ranking!(id)
    changeset = Portfolio.change_ranking(ranking)
    render(conn, "edit.html", ranking: ranking, changeset: changeset)
  end

  def update(conn, %{"id" => id, "ranking" => ranking_params}) do
    ranking = Portfolio.get_ranking!(id)

    case Portfolio.update_ranking(ranking, ranking_params) do
      {:ok, ranking} ->
        conn
        |> put_flash(:info, "Ranking updated successfully.")
        |> redirect(to: Routes.ranking_path(conn, :show, ranking))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", ranking: ranking, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ranking = Portfolio.get_ranking!(id)
    {:ok, _ranking} = Portfolio.delete_ranking(ranking)

    conn
    |> put_flash(:info, "Ranking deleted successfully.")
    |> redirect(to: Routes.ranking_path(conn, :index))
  end
end
