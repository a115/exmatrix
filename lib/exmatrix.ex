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
      Enum.map(new_b, &dot_product(row, &1))
    end)
  end

  @doc """
  Adds two matrices of the same dimensions, returning a new matrix of the
  same dimensions.  If two non-matching matrices are provided an ArgumentError
  will be raised.
  """
  @spec add([[number]], [[number]]) :: [[number]]
  def add(matrix_a, matrix_b) do
    case size(matrix_a) == size(matrix_b) do
      false -> raise ArgumentError, message: "Cannot add matrices of different dimensions"
      _ -> nil
    end

    Stream.zip(matrix_a, matrix_b)
    |> Enum.map(fn({a,b})-> add_rows(a, b) end)
  end

  @doc """
  Subtracts two matrices of the same dimensions, returning a new matrix of the
  same dimensions.  If two non-matching matrices are provided an ArgumentError
  will be raised.
  """
  @spec subtract([[number]], [[number]]) :: [[number]]
  def subtract(matrix_a, matrix_b) do
    case size(matrix_a) == size(matrix_b) do
      false -> raise ArgumentError, message: "Cannot add matrices of different dimensions"
      _ -> nil
    end

    Stream.zip(matrix_a, matrix_b)
    |> Enum.map(fn({a,b})-> subtract_rows(a, b) end)
  end

  @doc """
  Returns the size of the matrix as {rows, columns}.
  """
  @spec size([[number]]) :: {number, number}
  def size(matrix) do
    {length(matrix), length(Enum.at(matrix, 0))}
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

  @doc """
  Adds two rows together to return a new row
  """
  @spec add_rows([number], [number]) :: [number]
  def add_rows(row_a, row_b) do
    Stream.zip(row_a, row_b)
    |> Enum.map(fn({x, y}) -> x + y end)
  end

  @doc """
  Subtracts two rows to return a new row
  """
  @spec subtract_rows([number], [number]) :: [number]
  def subtract_rows(row_a, row_b) do
    Stream.zip(row_a, row_b)
    |> Enum.map(fn({x, y}) -> x - y end)
  end

  @doc """
  Append multiple rows to a matrix
  """
  @spec append_rows([[number]], [[number]]) :: [[number]]
  def append_rows(matrix, rows) when is_list(matrix) and is_list(rows) do
    if Enum.any?(rows, fn x -> !is_list(x) or Enum.any?(x, fn y -> !is_number(y) end) end) do
      raise "One of the rows has bad format"
    end
    {_, cols} = size(matrix)
    if Enum.all?(rows, fn x -> is_list(x) and length(x) == cols end) do
      Enum.reduce(rows, matrix, fn(row, mx) -> List.insert_at(mx, -1, row) end)
    else
      raise "One of the rows has a different length than the matrix's column length"
    end
  end
  def append_rows(_, _), do: raise "Matrix and rows have to be lists"

  @doc """
  Append 1 row to a matrix
  """
  @spec append_row([[number]], [number]) :: [[number]]
  def append_row(matrix, row) when is_list(matrix) and is_list(row) do
    if is_bitstring(row) or Enum.any?(row, fn x -> !is_number(x) end) do
      raise "The row has bad format"
    end
    {_, cols} = size(matrix)
    if length(row) == cols do
      List.insert_at(matrix, -1, row)
    else
      raise "The row has a different length than the matrix's column length"
    end
  end
  def append_row(_, _), do: raise "Matrix and row have to be lists"

  @doc """
  Append multiple columns to a matrix
  """
  @spec append_cols([[number]], [[number]]) :: [[number]]
  def append_cols(matrix, cols) when is_list(matrix) and is_list(cols) do
    if Enum.any?(cols, fn x -> !is_list(x) or Enum.any?(x, fn y -> !is_number(y) end) end) do
      raise "One of the cols has bad format"
    end
    {rows, _} = size(matrix)
    if Enum.all?(cols, fn x -> is_list(x) and length(x) == rows end) do
      #Enum.reduce(cols, matrix, fn(col, mx) -> mx |> Enum.zip(col) |> Enum.map(fn {row, col_item} -> List.insert_at(row, -1, col_item) end) end)
      Enum.reduce(cols, matrix, fn(col, mx) -> do_append_col(mx, col) end)
    else
      raise "One of the cols has a different length than the matrix's column length"
    end
  end
  def append_cols(_, _), do: raise "Matrix and cols have to be lists"

  @doc """
  Append 1 column to a matrix
  """
  @spec append_col([[number]], [number]) :: [[number]]
  def append_col(matrix, col) when is_list(matrix) and is_list(col) do
    if is_bitstring(col) or Enum.any?(col, fn x -> !is_number(x) end) do
      raise "The column has bad format"
    end
    {rows, _} = size(matrix)
    if length(col) == rows do
      do_append_col(matrix, col)
    else
      raise "The column has a different length than the matrix's row length"
    end
  end
  def append_col(_, _), do: raise "Matrix and col have to be lists"

  defp do_append_col(matrix, col) do
      matrix 
      |> Enum.zip(col)
      |> Enum.map(fn {row, col_item} -> List.insert_at(row, -1, col_item) end)
  end

  """
  Generates an Identity Matrix with 'size' rows and columns
  """
  @spec identity_matrix(integer) :: [[number]]
  def identity_matrix(size) do
    _identity(size, 0, [])
  end

  defp _identity(size, pos, matrix) when size == pos, do: matrix
  defp _identity(size, pos, matrix) do
    row = generate_zero_filled_row(size) |> List.replace_at(pos, 1)
    _identity(size, pos + 1, matrix |> List.insert_at(-1, row))
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
