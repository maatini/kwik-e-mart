defmodule KwikEMartWeb.PriceHelpers do
  def format_price(nil), do: ""

  def format_price(%Decimal{} = price) do
    price
    |> Decimal.round(2)
    |> Decimal.to_string(:normal)
    |> String.replace(".", ",")
    |> Kernel.<>(" €")
  end
end
