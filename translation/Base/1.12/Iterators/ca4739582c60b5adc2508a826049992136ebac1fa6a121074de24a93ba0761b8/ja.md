```julia
repeated(x[, n::Int])
```

値 `x` を永遠に生成するイテレータです。`n` が指定されている場合、`x` をその回数だけ生成します（`take(repeated(x), n)` と同等です）。

[`fill`](@ref Base.fill) も参照してください。また、[`Iterators.cycle`](@ref) と比較してください。

# 例

```jldoctest
julia> a = Iterators.repeated([1 2], 4);

julia> collect(a)
4-element Vector{Matrix{Int64}}:
 [1 2]
 [1 2]
 [1 2]
 [1 2]

julia> ans == fill([1 2], 4)
true

julia> Iterators.cycle([1 2], 4) |> collect |> println
[1, 2, 1, 2, 1, 2, 1, 2]
```
