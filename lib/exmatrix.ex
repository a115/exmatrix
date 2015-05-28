defmodule ExMatrix do
  @moduledoc """
  ExMatrix is an Elixir library implementing a parallel matrix multiplication
  algorithm and other utilitiy functions for working with matrices.

  ## Multiplying matrices

      iex> x = [[2,3], [3,5]]
      [[2,3], [3,5]]
      iex> y = [[1,2], [5,-1]]
      [[1,2], [5,-1]]
      iex> ExMatrix.pmultiply(x, y)
      [[17, 1], [28, 1]]
      iex> ExMatrix.multiply(x, y)
      [[17, 1], [28, 1]]

  """

  @doc """
  Creates a new matrix that has ```rows``` number of rows and
  ```cols``` columns. All cells are initially set to zero.

  # Example
      iex> ExMatrix.new_matrix(4, 5)
      [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
  """
  @spec new_matrix(number, number) :: [[number]]
  def new_matrix(rows, cols) do
    for n <- 1 .. rows, do: generate_zero_filled_row(cols)
  end


  @doc """
  Transposes the provided ```matrix``` so that a 3, 2 matrix would become
  a 2, 3 matrix. Once transposed the first row in the transposed matrix is
  actually the first column in the pre-transposed matrix.

  # Example
      iex> ExMatrix.transpose([[2, 4],[5, 6]])
      [[2, 5], [4, 6]]
  """
  @spec transpose([[number]]) :: [[number]]
  def transpose(cells) do
    transposed(cells)
  end

  defp transposed([[]|_]), do: []
  defp transposed(cells) do
    [ Enum.map(cells, fn(x) -> hd(x) end) | transposed(Enum.map(cells, fn(x) -> tl(x) end))]
  end


  @doc """
  Perform a sequential multiplication of the two matrices,
  ```matrix_a``` and ```matrix_b```.
  """
  @spec multiply([[number]], [[number]]) :: [[number]]
  def multiply(matrix_a, matrix_b) do
    new_b = transpose(matrix_b)

    Enum.map(matrix_a, fn(row)->
      Enum.map(new_b, &dot_product(row, &1))
    end)
  end


  @doc """
  Perform a parallel multiplication of the two matrices,
  ```matrix_a``` and ```matrix_b```.
  """
  @spec pmultiply([[number]], [[number]]) :: [[number]]
  def pmultiply(matrix_a, matrix_b) do
    new_b = transpose(matrix_b)

    pmap(matrix_a, fn(row)->
      pmap(new_b, &dot_product(row, &1))
    end)
  end


  @doc """
  Calculates the dot-product for two rows of numbers
  """
  @spec dot_product([number], [number]) :: number
  def dot_product(row_a, row_b) do
    Stream.zip(row_a, row_b)
    |> Enum.map(fn({x, y}) -> x * y end)
    |> Enum.sum
  end

  """
  Generates a zero-filled list of ```size``` elements, primarily used
  by the default new_matrix function.
  """
  @spec generate_zero_filled_row(integer) :: [number]
  defp generate_zero_filled_row(size) do
    Enum.map(:lists.seq(1, size), fn(x)-> 0 end)
  end

  """
  Perform a parallel map by calling the function against each element
  in a new process.
  """
  @spec pmap([number], fun) :: [number]
  defp pmap(collection, function) do
    me = self

    collection
    |> Enum.map(fn (elem) ->
      spawn_link fn -> (send me, { self, function.(elem) }) end
    end)
    |> Enum.map(fn (pid) ->
      receive do { ^pid, result } -> result end
    end)
  end


  """
  Generates a random matrix just so we can test large matrices
  """
  @spec random_cells(integer, integer, integer) :: [[number]]
  def random_cells(rows, cols, max) do
    :random.seed()

    Enum.map(:lists.seq(1, rows), fn(_)->
      :lists.seq(1, cols)
      |> Enum.map(fn(_)-> :random.uniform(max) end)
    end)
  end

end