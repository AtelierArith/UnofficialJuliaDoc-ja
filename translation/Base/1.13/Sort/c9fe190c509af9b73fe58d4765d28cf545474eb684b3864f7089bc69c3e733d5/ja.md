```julia
sortperm!(ix, A; alg::Base.Sort.Algorithm=Base.Sort.DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward, [dims::Integer])
```

[`sortperm`](@ref)と同様ですが、あらかじめ確保されたインデックスベクトルまたは配列`ix`を受け取ります。この配列は、`A`と同じ`axes`を持つ必要があります。`ix`は、値`LinearIndices(A)`を含むように初期化されます。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


!!! compat "Julia 1.9"
    `dims`を受け取るメソッドの使用には、Julia 1.9以降が必要です。


# Examples

```jldoctest
julia> v = [3, 1, 2]; p = zeros(Int, 3);

julia> sortperm!(p, v); p
3-element Vector{Int64}:
 2
 3
 1

julia> v[p]
3-element Vector{Int64}:
 1
 2
 3

julia> A = [8 7; 5 6]; p = zeros(Int,2, 2);

julia> sortperm!(p, A; dims=1); p
2×2 Matrix{Int64}:
 2  4
 1  3

julia> sortperm!(p, A; dims=2); p
2×2 Matrix{Int64}:
 3  1
 2  4
```
