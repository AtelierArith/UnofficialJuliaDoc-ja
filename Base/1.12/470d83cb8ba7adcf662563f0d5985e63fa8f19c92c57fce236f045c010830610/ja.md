```julia
collect(iterator)
```

コレクションまたはイテレータ内のすべてのアイテムの `Array` を返します。辞書の場合、`key=>value` [Pair](@ref Pair) の `Vector` を返します。引数が配列のようであるか、[`HasShape`](@ref IteratorSize) 特性を持つイテレータである場合、結果は引数と同じ形状および次元数になります。

[comprehensions](@ref man-comprehensions) によって [generator expression](@ref man-generators) を `Array` に変換するために使用されます。したがって、*ジェネレータに対して*、角括弧の表記法を使用して `collect` を呼び出す代わりに使用できます。2番目の例を参照してください。

返される配列の要素型は、収集された値の型に基づいています。ただし、イテレータが空である場合、返される（空の）配列の要素型は型推論によって決定されます。

# 例

`UnitRange{Int64}` コレクションからアイテムを収集します：

```jldoctest
julia> collect(1:3)
3-element Vector{Int64}:
 1
 2
 3
```

ジェネレータからアイテムを収集します（出力は `[x^2 for x in 1:3]` と同じです）：

```jldoctest
julia> collect(x^2 for x in 1:3)
3-element Vector{Int64}:
 1
 4
 9
```

結果の型が型推論に依存する空のイテレータを収集します：

```jldoctest
julia> [rand(Bool) ? 1 : missing for _ in []]
Union{Missing, Int64}[]
```

イテレータが空でない場合、結果の型は値のみに依存します：

```julia-repl
julia> [rand(Bool) ? 1 : missing for _ in [""]]
1-element Vector{Int64}:
 1
```
