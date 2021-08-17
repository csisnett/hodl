defmodule Hodl.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Hodl.Repo

  alias Hodl.Accounts.{Setting, Plan, Subscription}
  alias Hodl.Portfolio
  alias Hodl.Users.User

  @user_editable_settings ["timezone"]

  # Map -> {:ok, %User{}}, || {:error, %User{}}
  def create_user(user_params) do
    changeset = User.changeset(%User{}, user_params)
    case changeset.valid?  do
      true ->
        Repo.transaction(fn ->
        {:ok, user} = Repo.insert(changeset) # {:ok, User{}}
        %{"user_id" => user.id, "setting_key" => "timezone", "value" => user_params["timezone"]}
        |> create_setting()

        free_plan = Repo.get_by(Plan, id: 1)
        create_subscription(user, free_plan)

        user
        end)
      false -> {:error, changeset}
    end
  end

  # %User{} -> %Plan{}
  # Outputs the user's current plan
  def get_current_plan(%User{} = user) do
    query1 = from s in Subscription, where: s.user_id == ^user.id and is_nil(s.left_at), preload: [:plan]
    subscription = Repo.one(query1)
    subscription.plan
  end

  # %User{} -> Integer || String
  # Given the user it outputs how many email alerts the user can create according to his plan
  def email_alerts_remaining(%User{} = user) do
    plan = get_current_plan(user)
    active_alerts = Portfolio.list_user_active_quote_alerts(user) |> Enum.count()
    remaining = plan.email_limit - active_alerts

    cond do
      remaining > 0 -> remaining
      remaining == 0 -> remaining
      remaining < 0 -> "less than 0" # a user shouldn't have more alerts than available in their plan( maybe it happens if they downgrade plans)
    end
  end

  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Setting{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %Setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting!(id), do: Repo.get!(Setting, id)

  @doc """
  Creates a setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %Setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

      iex> update_setting(setting, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a setting.

  ## Examples

      iex> delete_setting(setting)
      {:ok, %Setting{}}

      iex> delete_setting(setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.

  ## Examples

      iex> change_setting(setting)
      %Ecto.Changeset{data: %Setting{}}

  """
  def change_setting(%Setting{} = setting, attrs \\ %{}) do
    Setting.changeset(setting, attrs)
  end

  # User -> String
  # Receives an user outputs the user's timezone
  def get_user_timezone(%User{} = user) do
    setting = Repo.one(from s in Setting,
     where: s.user_id == ^user.id and s.setting_key == "timezone",
     select: s)
    setting.value
  end

    # String -> %DateTime{}
  # Creates a DateTime for the present in the timezone given.
  def create_local_present_datetime(timezone) do
    {:ok, local_present_datetime} = DateTime.now(timezone, Tzdata.TimeZoneDatabase)
    local_present_datetime
  end

  @doc """
  Returns the list of plans.

  ## Examples

      iex> list_plans()
      [%Plan{}, ...]

  """
  def list_plans do
    Repo.all(Plan)
  end

  @doc """
  Gets a single plan.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan!(123)
      %Plan{}

      iex> get_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plan!(id), do: Repo.get!(Plan, id)

  @doc """
  Creates a plan.

  ## Examples

      iex> create_plan(%{field: value})
      {:ok, %Plan{}}

      iex> create_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plan(attrs \\ %{}) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Repo.insert()
  end

  def create_free_plan() do
    {:ok, free_plan} = create_plan(%{"name" => "free", "email_limit" => 5, "sms_limit" => 0})
  end

  def create_platinum_plan() do
    {:ok, platinum_plan} = create_plan(%{"name" => "platinum", "email_limit" => 1_000_000, "sms_limit" => 100})
  end

  def create_plans() do
    {:ok, free_plan} = create_plan(%{"name" => "free", "email_limit" => 5, "sms_limit" => 0})
    {:ok, paid_plan} = create_plan(%{"name" => "platinum", "email_limit" => 1_000_000, "sms_limit" => 100})
  end

  @doc """
  Updates a plan.

  ## Examples

      iex> update_plan(plan, %{field: new_value})
      {:ok, %Plan{}}

      iex> update_plan(plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plan(%Plan{} = plan, attrs) do
    plan
    |> Plan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a plan.

  ## Examples

      iex> delete_plan(plan)
      {:ok, %Plan{}}

      iex> delete_plan(plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plan(%Plan{} = plan) do
    Repo.delete(plan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plan changes.

  ## Examples

      iex> change_plan(plan)
      %Ecto.Changeset{data: %Plan{}}

  """
  def change_plan(%Plan{} = plan, attrs \\ %{}) do
    Plan.changeset(plan, attrs)
  end

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    Repo.all(Subscription)
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get!(Subscription, id)

  @doc """
  Creates a subscription.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end


  # %User{}, %Plan{} -> {:ok, %Subscription{}} || {:error, %Changeset{}}
  # Creates a Subscription for the user given to the plan given
  def create_subscription(%User{} = user, %Plan{} = plan) do
    user_timezone = get_user_timezone(user)
    local_datetime = create_local_present_datetime(user_timezone)
    naive_datetime = DateTime.to_naive(local_datetime)

    %{"user_id" => user.id, "plan_id" => plan.id, "joined_at" => naive_datetime, "joined_timezone" => user_timezone}
    |> create_subscription()
  end

  # %User{}, %Plan{} -> {:ok, {:ok, %Subscription{}}} || Some sort of error
  # Finishes the current subscription of the user and creates a new subscription for the new plan
  def change_user_to_plan(%User{} = user, %Plan{} = plan) do
    current_subscription = current_user_subscription(user)

    user_timezone = get_user_timezone(user)
    local_datetime = create_local_present_datetime(user_timezone)
    naive_datetime = DateTime.to_naive(local_datetime)

    Repo.transaction(fn ->
    update_subscription(current_subscription, %{"left_at" => naive_datetime, "left_timezone" => user_timezone})
    create_subscription(user, plan)
    end)

  end

  def list_user_subscriptions(%User{} = user) do
    query = from s in Subscription,
    where: s.user_id == ^user.id,
    select: s
    Repo.all(query)
  end

  # User -> Subscription || nil
  # Receives a user and outputs the user's last subscription or nil if it doesn't have any
  def current_user_subscription(%User{} = user) do
    last_subscription_query =
    from s in Subscription,
    where: s.user_id == ^user.id and is_nil(s.left_at),
    select: s
    Repo.one(last_subscription_query)
  end

  # User, Plan -> Subscription
  # Subscribes the given user to the plan given
  def subscribe_user_to_plan(%User{} = user, %Plan{} = plan) do
    plan
  end

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{data: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription, attrs \\ %{}) do
    Subscription.changeset(subscription, attrs)
  end
end
