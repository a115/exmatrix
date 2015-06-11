defmodule ExMatrix.NIF do
  @on_load :init


  def init do
    :erlang.load_nif("./priv/lib_matrix", 0)
  end

  def dotproduct(row_a, row_b) when is_list(row_a) and is_integer(hd(row_a)) do
    _dotproduct_int(row_a, row_b)
  end

  def dotproduct(row_a, row_b) when is_list(row_a) do
    _dotproduct_float(row_a, row_b)
  end

  def _dotproduct_int(_, _) do
    "NIF library not loaded"
  end

  def _dotproduct_float(_, _) do
    "NIF library not loaded"
  end


end