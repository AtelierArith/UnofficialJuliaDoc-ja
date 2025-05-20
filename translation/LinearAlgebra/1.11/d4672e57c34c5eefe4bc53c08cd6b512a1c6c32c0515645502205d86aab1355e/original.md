```
eigvals!(A; permute::Bool=true, scale::Bool=true, sortby) -> values
```

Same as [`eigvals`](@ref), but saves space by overwriting the input `A`, instead of creating a copy. The `permute`, `scale`, and `sortby` keywords are the same as for [`eigen`](@ref).

!!! note
    The input matrix `A` will not contain its eigenvalues after `eigvals!` is called on it - `A` is used as a workspace.


# Examples

```jldoctest
julia> A = [1. 2.; 3. 4.]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> eigvals!(A)
2-element Vector{Float64}:
 -0.3722813232690143
  5.372281323269014

julia> A
2×2 Matrix{Float64}:
 -0.372281  -1.0
  0.0        5.37228
```
