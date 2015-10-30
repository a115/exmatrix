defmodule ExMatrixIdentityTest do
  use ExUnit.Case
  import ExMatrix

  test "create an identity matrix of size 2" do
    i = identity_matrix(2)
    assert i == [[1, 0], [0, 1]]
  end

  test "create an identity matrix of size 5" do
    i = identity_matrix(5)
    assert i == [
                 [1, 0, 0, 0, 0],
                 [0, 1, 0, 0, 0],
                 [0, 0, 1, 0, 0],
                 [0, 0, 0, 1, 0],
                 [0, 0, 0, 0, 1],
                ]
  end

  test "any matrix multiplied by it's corresponding identity matrix equals itself" do
    a = [[1, 2, 3], [3, 4, 5], [5, 6, 7]]
    i = identity_matrix(3)
    assert i == [
                 [1, 0, 0],
                 [0, 1, 0],
                 [0, 0, 1],
                ]
    assert multiply(a, i) == a
  end
end
