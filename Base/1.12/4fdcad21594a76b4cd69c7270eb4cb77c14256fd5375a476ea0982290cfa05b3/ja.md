```julia
filter(f)
```

関数 `f` を使用して引数をフィルタリングする関数を作成します。これは、`x -> filter(f, x)` に相当する関数です。

返される関数は `Base.Fix1{typeof(filter)}` 型であり、特化したメソッドを実装するために使用できます。

# 例

```jldoctest
julia> (1, 2, Inf, 4, NaN, 6) |> filter(isfinite)
(1, 2, 4, 6)

julia> map(filter(iseven), [1:3, 2:4, 3:5])
3-element Vector{Vector{Int64}}:
 [2]
 [2, 4]
 [4]
```

!!! compat "Julia 1.9"
    このメソッドは少なくとも Julia 1.9 を必要とします。

