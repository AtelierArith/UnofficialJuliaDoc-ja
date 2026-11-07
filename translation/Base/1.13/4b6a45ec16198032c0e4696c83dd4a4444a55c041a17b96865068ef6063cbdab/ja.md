```julia
count([f=identity,] A::AbstractArray; dims=:)
```

指定された次元にわたって、`A` の要素のうち、`f` が `true` を返すものの数を数えます。

!!! compat "Julia 1.5"
    `dims` キーワードは Julia 1.5 で追加されました。


!!! compat "Julia 1.6"
    `init` キーワードは Julia 1.6 で追加されました。


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> count(<=(2), A, dims=1)
1×2 Matrix{Int64}:
 1  1

julia> count(<=(2), A, dims=2)
2×1 Matrix{Int64}:
 2
 0
```
