```julia
dropzeros(x::AbstractCompressedVector)
```

`x` のコピーを生成し、そのコピーから数値のゼロを取り除きます。

インプレース版とアルゴリズムの詳細については、[`dropzeros!`](@ref) を参照してください。

# Examples

```jldoctest
julia> A = sparsevec([1, 2, 3], [1.0, 0.0, 1.0])
3-element SparseVector{Float64, Int64} with 3 stored entries:
  [1]  =  1.0
  [2]  =  0.0
  [3]  =  1.0

julia> dropzeros(A)
3-element SparseVector{Float64, Int64} with 2 stored entries:
  [1]  =  1.0
  [3]  =  1.0
```
