```julia
Tridiagonal(dl::V, d::V, du::V) where V <: AbstractVector
```

Construct a tridiagonal matrix from the first subdiagonal, diagonal, and first superdiagonal, respectively. The result is of type `Tridiagonal` and provides efficient specialized linear solvers, but may be converted into a regular matrix with [`convert(Array, _)`](@ref) (or `Array(_)` for short). The lengths of `dl` and `du` must be one less than the length of `d`.

!!! note
    The subdiagonal `dl` and the superdiagonal `du` must not be aliased to each other. If aliasing is detected, the constructor will use a copy of `du` as its argument.


# Examples

```jldoctest
julia> dl = [1, 2, 3];

julia> du = [4, 5, 6];

julia> d = [7, 8, 9, 0];

julia> Tridiagonal(dl, d, du)
4×4 Tridiagonal{Int64, Vector{Int64}}:
 7  4  ⋅  ⋅
 1  8  5  ⋅
 ⋅  2  9  6
 ⋅  ⋅  3  0
```
