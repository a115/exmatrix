defmodule ExMatrixSubtractionTest do
  use ExUnit.Case
  import ExMatrix

  test "test addition of valid size matrices" do
    assert subtract([[0, 1, 2], [9, 8, 7]], [[6, 5, 4], [3, 4, 5]]) ==
      [[-6, -4, -2], [6, 4, 2]]
  end

  test "test subtraction of mis-matched matrices" do
    assert_raise ArgumentError, fn ->
      subtract([[0]], [[1,1]])
    end
  end

end