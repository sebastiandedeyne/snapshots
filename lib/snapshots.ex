defmodule Snapshots do
  @moduledoc """
  Documentation for Snapshots.
  """

  defmacro __using__(_opts) do
    quote do
      import Snapshots, only: :macros
    end
  end

  defmacro assert_snapshot(expected, driver \\ Snapshots.Drivers.Text) do
    quote do
      snapshot = Snapshots.create(__ENV__, unquote(driver))

      if Snapshots.exists?(snapshot) do
        assert unquote(expected) == Snapshots.read(snapshot)
      else
        Snapshots.write(snapshot, unquote(expected))
      end
    end
  end

  def create(env, driver) do
    %Snapshots.Snapshot{
      name: get_name(env),
      dir: get_dir(env),
      driver: driver
    }
  end

  def read(snapshot) do
    File.read!(path(snapshot))
  end

  def write(snapshot, contents) do
    File.mkdir_p!(snapshot.dir)

    File.write!(path(snapshot), contents)
  end

  def exists?(snapshot) do
    File.exists?(path(snapshot))
  end

  defp path(snapshot) do
    Path.join(snapshot.dir, snapshot.name <> apply(snapshot.driver, :extension, []))
  end

  defp get_name(env) do
    env.function
    |> case do {test, _} -> test end
    |> Atom.to_string()
    |> String.replace(" ", "_")
    |> String.replace_leading("test_", "")
  end

  defp get_dir(env) do
    env.file
    |> Path.dirname()
    |> Path.join("__snapshots__")
  end
end
