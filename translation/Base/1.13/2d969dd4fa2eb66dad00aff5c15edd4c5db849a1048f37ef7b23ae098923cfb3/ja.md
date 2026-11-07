```julia
collect(iterator)
```

コレクションまたはイテレータのすべての要素を含む`Array`を返します。辞書の場合は、`Vector`の`key=>value` [Pair](@ref Pair)を返します。引数が配列のようなオブジェクトであるか、[`HasShape`](@ref IteratorSize)トレイトを持つイテレータの場合、結果は引数と同じ形状および次元数になります。

[comprehensions](@ref man-comprehensions)が[generator expression](@ref man-generators)を`Array`に変換する際に使用されます。そのため、*ジェネレータでは*、角括弧の記法を使って`collect`の呼び出しを置き換えられます。2つ目の例を参照してください。

返される配列の要素型は、収集された値の型に基づいて決まります。ただし、イテレータが空の場合、返される（空の）配列の要素型は型推論によって決まります。

# Examples

`UnitRange{Int64}`コレクションから要素を収集します。

```jldoctest
julia> collect(1:3)
3-element Vector{Int64}:
 1
 2
 3
```

ジェネレータから要素を収集します（`[x^2 for x in 1:3]`と同じ出力）。

```jldoctest
julia> collect(x^2 for x in 1:3)
3-element Vector{Int64}:
 1
 4
 9
```

結果の型が型推論に依存する、空のイテレータからの収集：

```jldoctest
julia> [rand(Bool) ? 1 : missing for _ in []]
Union{Missing, Int64}[]
```

イテレータが空でない場合、結果の型は値のみに依存します。

```julia-repl
julia> [rand(Bool) ? 1 : missing for _ in [""]]
1-element Vector{Int64}:
 1
```
