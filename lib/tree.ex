defmodule Tree do
  @moduledoc """
  Documentation for Tree.
  """

  @doc """
  make
  ## Examples
      iex> Tree.make([])
      {:EMPTY}

      iex> Tree.make([1])
      {:NODE, {:EMPTY}, 1, {:EMPTY}}

      iex> Tree.make([1, 2])
      {:NODE, {:LEAF, 1}, 2, {:EMPTY}}

      iex> Tree.make([1, 2, 3])
      {:NODE, {:LEAF, 1}, 2, {:LEAF, 3}}

      iex> Tree.make([1, 2, 3, 4])
      {:NODE, {:NODE, {:LEAF, 1}, 2, {:EMPTY}}, 3, {:NODE, {:EMPTY}, 4, {:EMPTY}}}

      iex> Tree.make([1, 2, 3, 4, 5])
      {:NODE, {:NODE, {:LEAF, 1}, 2, {:EMPTY}}, 3, {:NODE, {:LEAF, 4}, 5, {:EMPTY}}}

      iex> Tree.make([1, 2, 3, 4, 5, 6])
      {:NODE, {:NODE, {:LEAF, 1}, 2, {:LEAF, 3}}, 4, {:NODE, {:LEAF, 5}, 6, {:EMPTY}}}

      iex> Tree.make([1, 2, 3, 4, 5, 6, 7])
      {:NODE, {:NODE, {:LEAF, 1}, 2, {:LEAF, 3}}, 4, {:NODE, {:LEAF, 5}, 6, {:LEAF, 7}}}
  """
  def make(list), do: Enum.uniq(list) |> Enum.sort() |> do_make()
  defp do_make(list) do
    count = Enum.count(list)
    cond do
      count < 4 -> list
                   |> make_node(count)
      true      -> list
                   |> list_splited_three_by_center(count)
                   |> make_node_branch()
    end
  end
  defp list_splited_three_by_center(list, count) do
    div(count, 2)
    |> build_list(list)
  end
  defp build_list(center, list), do: list |> Enum.chunk_by(fn(x) -> x==Enum.at(list, center) end)
  defp make_node_branch(list) do
    node_branch(
      do_make(Enum.at(list, 0)),
      Enum.at(list, 1) |> hd,
      do_make(Enum.at(list, 2))
    )
  end
  defp node_branch(left, v, right), do: {:NODE, left, v, right}

  defp make_node(list, count) do
    cond do
      count == 0 -> empty()
      count == 1 -> node(nil, Enum.at(list, 0), nil)
      count == 2 -> node(Enum.at(list, 0), Enum.at(list, 1), nil)
      true       -> node(Enum.at(list, 0), Enum.at(list, 1), Enum.at(list, 2))
    end
  end
  defp empty(), do: {:EMPTY}
  defp leaf(v), do: {:LEAF, v}
  defp node(nil, v, nil), do: {:NODE, empty(), v, empty()}
  defp node(left, v, nil), do: {:NODE, leaf(left), v, empty()}
  defp node(left, v, right), do: {:NODE, leaf(left), v, leaf(right)}

  @doc """
  insert
  ## Examples
      iex> Tree.insert({:NODE, {:LEAF, 10}, 11, {:LEAF, 12}}, 45)
      {:NODE, {:LEAF, 10}, 11, {:NODE, {:LEAF, 12}, 45, {:EMPTY}}}
  """
  def insert(tree, element), do: do_insert(tree, element)
  defp do_insert({:EMPTY}, element), do: {:NODE, {:EMPTY}, element, {:EMPTY}}
  defp do_insert({:LEAF, v}, element) when v == element, do: {:LEAF, element}
  defp do_insert({:LEAF, v}, element) when v > element, do: {:NODE, {:EMPTY}, element, {:LEAF, v}}
  defp do_insert({:LEAF, v}, element) when v < element, do: {:NODE, {:LEAF, v}, element, {:EMPTY}}
  defp do_insert({:NODE, left, v, right}, element) when v == element, do: {:NODE, left, element, right}
  defp do_insert({:NODE, left, v, right}, element) when v > element, do: {:NODE, do_insert(left, element), v, right}
  defp do_insert({:NODE, left, v, right}, element) when v < element, do: {:NODE, left, v, do_insert(right, element)}

  @doc """
  search
  ## Examples
      iex> Tree.search({:NODE, {:LEAF, 10}, 11, {:NODE, {:LEAF, 12}, 45, {:EMPTY}}}, 45)
      {:true, 45}

      iex> Tree.search({:NODE, {:LEAF, 10}, 11, {:NODE, {:LEAF, 12}, 45, {:EMPTY}}}, 9)
      {:false, 9}
  """
  def search(tree, element), do: do_search(tree, element)
  defp do_search({:EMPTY}, element), do: {:false, element}
  defp do_search({:LEAF, v}, element) when v == element, do: {:true, element}
  defp do_search({:LEAF, _}, element), do: {:false, element}
  defp do_search({:NODE, _, v, _}, element) when v == element, do: {:true, element}
  defp do_search({:NODE, left, v, _}, element) when v > element, do: do_search(left, element)
  defp do_search({:NODE, _, v, right}, element) when v < element, do: do_search(right, element)

end
