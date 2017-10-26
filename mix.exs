defmodule Snapshots.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :snapshots,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: "Snapshot assertions for ExUnit.",
       package: package(),
       deps: deps(),
       docs: [
         extras: ["README.md"],
         main: "readme",
         source_ref: "v#{@version}",
         source_url: "https://github.com/sebastiandedeyne/snapshots"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  defp package do
    [
      name: :snapshots,
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Sebastian De Deyne"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sebastiandedeyne/snapshots"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
