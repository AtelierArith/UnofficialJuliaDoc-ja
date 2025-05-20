```
adjoint!(dest,src)
```

共役転置配列 `src` を計算し、その結果を事前に確保された配列 `dest` に格納します。`dest` のサイズは `(size(src,2),size(src,1))` に対応している必要があります。インプレースの転置はサポートされておらず、`src` と `dest` が重複するメモリ領域を持つ場合、予期しない結果が生じる可能性があります。

# 例

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
