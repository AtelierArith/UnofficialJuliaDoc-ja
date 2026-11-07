```julia
clamp(x, T)::T
```

`x`を`typemin(T)`と`typemax(T)`の間に収め、その結果を型`T`に変換します。

こちらも参照してください：[`trunc`](@ref)。

# Examples

```jldoctest
julia> clamp(200, Int8)
127

julia> clamp(-200, Int8)
-128

julia> trunc(Int, 4pi^2)
39
```
