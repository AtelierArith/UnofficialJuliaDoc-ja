```julia
prod(f, A::AbstractArray; dims)
```

指定された次元に沿って、配列の各要素に対して関数 `f` を呼び出し、その結果を乗算します。

# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> prod(abs2, A, dims=1)
1×2 Matrix{Int64}:
 9  64

julia> prod(abs2, A, dims=2)
2×1 Matrix{Int64}:
   4
 144
```
