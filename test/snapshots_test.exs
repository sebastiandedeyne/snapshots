defmodule SnapshotsTest do
  use ExUnit.Case
  use Snapshots
  doctest Snapshots

  test "assert an existing snapshot" do
    assert_snapshot "Hello, world!"
  end

  test "create a new snapshot" do
    assert_snapshot "Hello, world!"

    path = "test/__snapshots__/create_a_new_snapshot.txt"

    assert File.exists?(path) == true

    File.rm!(path)
  end
end
