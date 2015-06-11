defmodule ExMatrix.NIF do
  @on_load :init


  def init do
    :erlang.load_nif("./priv/lib_matrix", 0)
  end

  def dotproduct(row_a, row_b) do
    _dotproduct(row_a, row_b)
  end

  def _dotproduct(_, _) do
    "NIF library not loaded"
  end


end