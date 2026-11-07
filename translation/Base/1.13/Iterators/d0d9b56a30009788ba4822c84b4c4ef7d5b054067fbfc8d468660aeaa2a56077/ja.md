```julia
repeated(x[, n::Int])
```

値 `x` を無限に生成するイテレーターです。`n` を指定すると、その回数だけ `x` を生成します（`take(repeated(x), n)` と同等です）。

[`fill`](@ref Base.fill) も参照してください。また、[`Iterators.cycle`](@ref) と比較してください。

# Examples

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
