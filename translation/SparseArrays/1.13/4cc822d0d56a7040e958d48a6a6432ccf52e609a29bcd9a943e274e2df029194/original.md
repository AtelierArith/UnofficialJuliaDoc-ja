```julia
mergeinds!(C::AbstractSparseMatrixCSC, A::AbstractSparseMatrixCSC)
```

Update `C` to contain stored values corresponding to the stored indices of `A`. Stored indices common to `C` and `A` are not touched. Indices of `A` at which `C` did not have a stored value are populated with zeros after the call.

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
