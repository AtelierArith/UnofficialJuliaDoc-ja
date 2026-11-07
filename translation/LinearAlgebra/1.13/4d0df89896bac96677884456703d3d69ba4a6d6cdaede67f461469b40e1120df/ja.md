```julia
transpose!(dest,src)
```

配列 `src` を転置し、その結果を事前に確保した配列 `dest` に格納します。この配列のサイズは `(size(src,2),size(src,1))` に対応している必要があります。インプレース転置はサポートされていません。また、`src` と `dest` のメモリ領域が重なっている場合、予期しない結果が生じます。

# Examples

```jldoctest
julia> A = [3+2im 9+2im; 8+7im  4+6im]
2×2 Matrix{Complex{Int64}}:
 3+2im  9+2im
 8+7im  4+6im

julia> B = zeros(Complex{Int64}, 2, 2)
2×2 Matrix{Complex{Int64}}:
 0+0im  0+0im
 0+0im  0+0im

julia> transpose!(B, A);

julia> B
2×2 Matrix{Complex{Int64}}:
 3+2im  8+7im
 9+2im  4+6im

julia> A
2×2 Matrix{Complex{Int64}}:
 3+2im  9+2im
 8+7im  4+6im
```
