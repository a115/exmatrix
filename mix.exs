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
     compilers: [:make, :elixir, :app],
     aliases: aliases,
     package: package]
  end

  defp aliases do
    # Execute the usual mix clean and our Makefile clean task
    [clean: ["clean", "clean.make"]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:benchfella, "~> 0.2.0"},
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


defmodule Mix.Tasks.Compile.Make do
  @shortdoc "Compiles helper in c_src"

  def run(_) do
    {result, _error_code} = System.cmd("make", [], stderr_to_stdout: true)
    Mix.shell.info result

    :ok
  end
end

defmodule Mix.Tasks.Clean.Make do
  @shortdoc "Cleans helper in c_src"

  def run(_) do
    {result, _error_code} = System.cmd("make", ['clean'], stderr_to_stdout: true)
    Mix.shell.info result

    :ok
  end
end