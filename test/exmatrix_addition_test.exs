defmodule ExMatrixAdditionTest do
  use ExUnit.Case
  import ExMatrix

  test "test addition of valid size matrices" do
    assert add([[0, 1, 2], [9, 8, 7]], [[6, 5, 4], [3, 4, 5]]) ==
      [[6, 6, 6], [12, 12, 12]]
  end

  test "test addition of mis-matched matrices" do
    assert_raise ArgumentError, fn ->
      add([[0]], [[1,1]])
    end
  end

end