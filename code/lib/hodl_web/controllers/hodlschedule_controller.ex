defmodule HodlWeb.HodlscheduleController do
  use HodlWeb, :controller

  alias Hodl.Portfolio
  alias Hodl.Portfolio.Hodlschedule

  def index(conn, _params) do
    hodlschedules = Portfolio.list_hodlschedules()
    render(conn, "index.html", hodlschedules: hodlschedules)
  end

  def new(conn, _params) do
    changeset = Portfolio.change_hodlschedule(%Hodlschedule{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hodlschedule" => hodlschedule_params}) do
    cleaned_cycles = clean_cycles(hodlschedule_params["cycles"])
    hodlschedule_params = Map.put(hodlschedule_params, "cycles", cleaned_cycles)
    default_user = Portfolio.get_user!(1)

    case Portfolio.create_hodlschedule(hodlschedule_params, default_user) do
      {:ok, hodlschedule} ->
        conn
        |> put_flash(:info, "Hodlschedule created successfully.")
        |> redirect(to: Routes.hodlschedule_path(conn, :show, hodlschedule))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def clean_cycles(cycles) when is_list(cycles) do
    Enum.map(cycles, fn cycle -> prepare_cycle(cycle) end)
    |> Enum.reverse()
  end

  def prepare_cycle(cycle) do
    %{"price_per_coin" => cycle["price_per_coin_num"],
      "amount_of_coin" => cycle["coin_amount"],
      "sale_percentage" => cycle["sell_percentage_num"]  
     }
  end

  def show(conn, %{"id" => id}) do
    hodlschedule = Portfolio.get_hodlschedule!(id)
    render(conn, "show.html", hodlschedule: hodlschedule)
  end

  def edit(conn, %{"id" => id}) do
    hodlschedule = Portfolio.get_hodlschedule!(id)
    changeset = Portfolio.change_hodlschedule(hodlschedule)
    render(conn, "edit.html", hodlschedule: hodlschedule, changeset: changeset)
  end

  def update(conn, %{"id" => id, "hodlschedule" => hodlschedule_params}) do
    hodlschedule = Portfolio.get_hodlschedule!(id)

    case Portfolio.update_hodlschedule(hodlschedule, hodlschedule_params) do
      {:ok, hodlschedule} ->
        conn
        |> put_flash(:info, "Hodlschedule updated successfully.")
        |> redirect(to: Routes.hodlschedule_path(conn, :show, hodlschedule))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", hodlschedule: hodlschedule, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hodlschedule = Portfolio.get_hodlschedule!(id)
    {:ok, _hodlschedule} = Portfolio.delete_hodlschedule(hodlschedule)

    conn
    |> put_flash(:info, "Hodlschedule deleted successfully.")
    |> redirect(to: Routes.hodlschedule_path(conn, :index))
  end
end
