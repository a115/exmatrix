defmodule ExMatrixTest do
  use ExUnit.Case
  import ExMatrix

  test "creating a matrix" do
    m = new_matrix(3, 3)
    assert m == [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  end

  test "transpose a matrix" do
    m = new_matrix(3, 2)
    n = transpose(m)
    assert m == [[0, 0],
                 [0, 0],
                 [0, 0]]
    assert n == [[0, 0, 0],
                 [0, 0, 0]]
  end

  test "simple sequential multiply" do
    x = [[2,3], [3,5]]
    y = [[1,2], [5,-1]]
    z = multiply(x, y)
    assert z == [[17, 1], [28, 1]]
  end

  test "simple parallel multiply" do
    x = [[2,3], [3,5]]
    y = [[1,2], [5,-1]]
    z = pmultiply(x, y)
    assert z == [[17, 1], [28, 1]]
  end

  test "large matrix sequentially" do
    random_a = random_cells(50, 50, 100)
    random_b = random_cells(50, 50, 100)
    result = multiply(random_a, random_b)
    assert length(result) == 50
  end

  test "large matrix parallel" do
    random_a = random_cells(50, 50, 100)
    random_b = random_cells(50, 50, 100)
    result = pmultiply(random_a, random_b)
    assert length(result) == 50
  end


end

