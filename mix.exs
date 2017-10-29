defmodule ExMatrix.Mixfile do
  use Mix.Project

  def project do
    [app: :exmatrix,
     version: "0.0.1",
     description: description,
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "ExMatrix",
     source_url: "https://github.com/a115/exmatrix",
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:benchfella, "~> 0.2.0", only: :dev},
     {:ex_doc, "~> 0.7", only: :dev}]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     contributors: ["Ross Jones"],
     licenses: ["Apache 2.0"],
     links: %{
       github: "https://github.com/a115/exmatrix",
       docs: "http://hexdocs.pm/exmatrix"
     }]
  end

  defp description do
    """
    ExMatrix is a small library for working with matrices, originally
    developed for testing matrix multiplication in parallel.
    """
  end

end
