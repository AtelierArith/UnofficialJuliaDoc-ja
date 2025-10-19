```julia
sort(v::Union{AbstractVector, NTuple}; alg::Base.Sort.Algorithm=Base.Sort.defalg(v), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

[`sort!`](@ref) のバリアントで、`v` のソートされたコピーを返し、`v` 自体は変更されません。

!!! compat "Julia 1.12"
    `NTuple` のソートには Julia 1.12 以降が必要です。


# 例

```jldoctest
julia> v = [3, 1, 2];

julia> sort(v)
3-element Vector{Int64}:
 1
 2
 3

julia> v
3-element Vector{Int64}:
 3
 1
 2
```
