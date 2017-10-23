defmodule Snapshots do
  @moduledoc """
  Documentation for Snapshots.
  """

  import ExUnit.Assertions

  defmacro __using__(_opts) do
    quote do
      import Snapshots, only: :macros
    end
  end

  defmacro test_snapshot(message, var \\ quote(do: _), contents) do
    contents =
      case contents do
        [do: block] ->
          quote do
            Snapshots.assert_snapshot(__ENV__, unquote(block))
            :ok
          end

        _ ->
          quote do
            Snapshots.assert_snapshot(__ENV__, try(unquote(contents)))
            :ok
          end
      end

    var = Macro.escape(var)
    contents = Macro.escape(contents, unquote: true)

    quote bind_quoted: [var: var, contents: contents, message: message] do
      name = ExUnit.Case.register_test(__ENV__, :test, message, [:not_implemented])
      def unquote(name)(unquote(var)), do: unquote(contents)
    end
  end

  def assert_snapshot(env, expected, driver \\ Snapshots.Drivers.Text) do
    snapshot = Snapshots.create(env, driver)

    if Snapshots.exists?(snapshot) do
      assert expected == Snapshots.read(snapshot)
    else
      Snapshots.write(snapshot, expected)
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
