```julia
mergeinds!(C::AbstractSparseMatrixCSC, A::AbstractSparseMatrixCSC)
```

`A` の格納済みインデックスに対応する値を格納するよう、`C` を更新します。`C` と `A` の両方に共通する格納済みインデックスは変更されません。呼び出し後、`C` に値が格納されていなかった `A` のインデックスには、ゼロが設定されます。

# Examples

```jldoctest
julia> A = spzeros(3,3);

julia> A[4:4:8] .= 1;

julia> A
3×3 SparseMatrixCSC{Float64, Int64} with 2 stored entries:
  ⋅   1.0   ⋅
  ⋅    ⋅   1.0
  ⋅    ⋅    ⋅

julia> C = spzeros(3,3);

julia> C[2:4:6] .= 2;

julia> C
3×3 SparseMatrixCSC{Float64, Int64} with 2 stored entries:
  ⋅    ⋅    ⋅
 2.0   ⋅    ⋅
  ⋅   2.0   ⋅

julia> SparseArrays.mergeinds!(C, A)
3×3 SparseMatrixCSC{Float64, Int64} with 4 stored entries:
  ⋅   0.0   ⋅
 2.0   ⋅   0.0
  ⋅   2.0   ⋅
```
