```julia
sort!(A; dims::Integer, alg::Base.Sort.Algorithm=Base.Sort.defalg(A), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

多次元配列`A`を、次元`dims`に沿ってソートします。指定可能なキーワード引数については、1次元版の[`sort!`](@ref)を参照してください。

配列のスライスをソートする方法については、[`sortslices`](@ref)を参照してください。

!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。


# Examples

```jldoctest
julia> A = [4 3; 1 2]
2×2 Matrix{Int64}:
 4  3
 1  2

julia> sort!(A, dims = 1); A
2×2 Matrix{Int64}:
 1  2
 4  3

julia> sort!(A, dims = 2); A
2×2 Matrix{Int64}:
 1  2
 3  4
```
