defmodule MatrixBench do
  use Benchfella
  import ExMatrix

  @random_a random_cells(50, 50, 100)
  @random_b random_cells(50, 50, 100)
  @random_a_large random_cells(100, 100, 100)
  @random_b_large random_cells(100, 100, 100)
  @random_a_qlarge random_cells(200, 200, 100)
  @random_b_qlarge random_cells(200, 200, 100)
  @random_a_vlarge random_cells(400, 400, 100)
  @random_b_vlarge random_cells(400, 400, 100)

  bench "transpose a 100x100 matrix" do
    transpose(@random_a_large)
  end

  bench "transpose a 200x200 matrix" do
    transpose(@random_a_qlarge)
  end

  bench "transpose a 400x400 matrix" do
    transpose(@random_a_vlarge)
  end

  bench "50x50 matrix in parallel" do
    pmultiply(@random_a, @random_b)
  end

  bench "100x100 matrix in parallel" do
    pmultiply(@random_a_large, @random_b_large)
  end

  bench "200x200 matrix in parallel" do
    pmultiply(@random_a_qlarge, @random_b_qlarge)
  end

  bench "400x400 matrix in parallel" do
    pmultiply(@random_a_vlarge, @random_b_vlarge)
  end

end