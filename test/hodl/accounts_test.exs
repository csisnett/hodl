defmodule Hodl.AccountsTest do
  use Hodl.DataCase

  alias Hodl.Accounts

  describe "settings" do
    alias Hodl.Accounts.Setting

    @valid_attrs %{setting_key: "some setting_key", value: "some value"}
    @update_attrs %{setting_key: "some updated setting_key", value: "some updated value"}
    @invalid_attrs %{setting_key: nil, value: nil}

    def setting_fixture(attrs \\ %{}) do
      {:ok, setting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_setting()

      setting
    end

    test "list_settings/0 returns all settings" do
      setting = setting_fixture()
      assert Accounts.list_settings() == [setting]
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Accounts.get_setting!(setting.id) == setting
    end

    test "create_setting/1 with valid data creates a setting" do
      assert {:ok, %Setting{} = setting} = Accounts.create_setting(@valid_attrs)
      assert setting.setting_key == "some setting_key"
      assert setting.value == "some value"
    end

    test "create_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_setting(@invalid_attrs)
    end

    test "update_setting/2 with valid data updates the setting" do
      setting = setting_fixture()
      assert {:ok, %Setting{} = setting} = Accounts.update_setting(setting, @update_attrs)
      assert setting.setting_key == "some updated setting_key"
      assert setting.value == "some updated value"
    end

    test "update_setting/2 with invalid data returns error changeset" do
      setting = setting_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_setting(setting, @invalid_attrs)
      assert setting == Accounts.get_setting!(setting.id)
    end

    test "delete_setting/1 deletes the setting" do
      setting = setting_fixture()
      assert {:ok, %Setting{}} = Accounts.delete_setting(setting)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_setting!(setting.id) end
    end

    test "change_setting/1 returns a setting changeset" do
      setting = setting_fixture()
      assert %Ecto.Changeset{} = Accounts.change_setting(setting)
    end
  end
end
