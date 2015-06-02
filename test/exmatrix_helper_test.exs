defmodule ExMatrixHelperTest do
  use ExUnit.Case
  import ExMatrix

  test "test matching size of matrix" do
    assert {2, 2} = size([[0,0], [0,0]])
  end

  test "test non-matching size of matrix" do
    refute {2, 2} = size([[0], [0]])
  end

end