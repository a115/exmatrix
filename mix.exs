defmodule ExMatrix.Mixfile do
  use Mix.Project

  def project do
    [app: :exmatrix,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "ExMatrix",
     source_url: "https://github.com/a115/exmatrix",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:benchfella, "~> 0.2.0"},
     {:ex_doc, "~> 0.7", only: :dev}]
  end
end
