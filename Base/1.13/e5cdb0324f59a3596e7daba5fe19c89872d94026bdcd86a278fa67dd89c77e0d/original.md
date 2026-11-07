```julia
@views expression
```

Convert every array-slicing operation in the given expression (which may be a `begin`/`end` block, loop, function, etc.) to return a view. Scalar indices, non-array types, and explicit [`getindex`](@ref) calls (as opposed to `array[...]`) are unaffected.

Similarly, `@views` converts string slices into [`SubString`](@ref) views.

!!! note
    The `@views` macro only affects `array[...]` expressions that appear explicitly in the given `expression`, not array slicing that occurs in functions called by that code.


!!! compat "Julia 1.5"
    Using `begin` in an indexing expression to refer to the first index was implemented in Julia 1.4, but was only supported by `@views` starting in Julia 1.5.


# Examples

```jldoctest
julia> A = zeros(3, 3);

julia> @views for row in 1:3
           b = A[row, :] # b is a view, not a copy
           b .= row      # assign every element to the row index
       end

julia> A
3×3 Matrix{Float64}:
 1.0  1.0  1.0
 2.0  2.0  2.0
 3.0  3.0  3.0
```
