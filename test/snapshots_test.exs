defmodule SnapshotsTest do
  use ExUnit.Case
  use Snapshots
  doctest Snapshots

  test "greets the world" do
    assert_snapshot "Hello, world!"
  end
end
