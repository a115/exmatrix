defmodule MatrixBench do
  use Benchfella
  import ExMatrix

  @random_a random_cells(50, 50, 100)
  @random_b random_cells(50, 50, 100)
  @random_a_large random_cells(100, 100, 100)
  @random_b_large random_cells(100, 100, 100)
  @random_a_vlarge random_cells(300, 300, 100)
  @random_b_vlarge random_cells(300, 300, 100)

  bench "50x50 matrix in parallel" do
    pmultiply(@random_a, @random_b)
  end

  bench "100x100 matrix in parallel" do
    pmultiply(@random_a_large, @random_b_large)
  end

  bench "300x300 matrix in parallel" do
    pmultiply(@random_a_vlarge, @random_b_vlarge)
  end

  bench "100x100 matrix in sequence" do
    multiply(@random_a_large, @random_b_large)
  end

  bench "transpose a 300x300 matrix" do
    transpose(@random_a_vlarge)
  end

  bench "transpose a 100x100 matrix" do
    transpose(@random_a_large)
  end

  bench "transpose a 50x50 matrix" do
    transpose(@random_a)
  end

end