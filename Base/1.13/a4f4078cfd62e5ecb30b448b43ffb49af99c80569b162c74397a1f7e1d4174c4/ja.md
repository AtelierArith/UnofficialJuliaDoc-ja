```julia
filter(f)
```

`f` を [`filter`](@ref) で使って引数をフィルタリングする関数を作成します。つまり、`x -> filter(f, x)` と同等の関数です。

返される関数の型は `Base.Fix1{typeof(filter)}` で、これを使って特化したメソッドを実装できます。

# Examples

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
    このメソッドには Julia 1.9 以降が必要です。

