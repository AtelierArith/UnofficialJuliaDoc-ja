```julia
adjoint!(dest,src)
```

配列 `src` の共役転置を行い、その結果を事前に確保した配列 `dest` に格納します。この配列のサイズは `(size(src,2),size(src,1))` に対応している必要があります。インプレース転置はサポートされていません。`src` と `dest` のメモリ領域が重複している場合、予期しない結果が生じます。

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

julia> adjoint!(B, A);

julia> B
2×2 Matrix{Complex{Int64}}:
 3-2im  8-7im
 9-2im  4-6im

julia> A
2×2 Matrix{Complex{Int64}}:
 3+2im  9+2im
 8+7im  4+6im
```
