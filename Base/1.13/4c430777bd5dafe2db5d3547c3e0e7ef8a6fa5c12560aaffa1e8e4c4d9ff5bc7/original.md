```julia
@view A[inds...]
```

Transform the indexing expression `A[inds...]` into the equivalent [`view`](@ref) call.

This can only be applied directly to a single indexing expression and is particularly helpful for expressions that include the special `begin` or `end` indexing syntaxes like `A[begin, 2:end-1]` (as those are not supported by the normal [`view`](@ref) function).

Note that `@view` cannot be used as the target of a regular assignment (e.g., `@view(A[1, 2:end]) = ...`), nor would the un-decorated [indexed assignment](@ref man-indexed-assignment) (`A[1, 2:end] = ...`) or broadcasted indexed assignment (`A[1, 2:end] .= ...`) make a copy.  It can be useful, however, for *updating* broadcasted assignments like `@view(A[1, 2:end]) .+= 1` because this is a simple syntax for `@view(A[1, 2:end]) .= @view(A[1, 2:end]) + 1`, and the indexing expression on the right-hand side would otherwise make a copy without the `@view`.

See also [`@views`](@ref) to switch an entire block of code to use views for non-scalar indexing.

!!! compat "Julia 1.5"
    Using `begin` in an indexing expression to refer to the first index requires at least Julia 1.5.


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> b = @view A[:, 1]
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 1
 3

julia> fill!(b, 0)
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 0
 0

julia> A
2×2 Matrix{Int64}:
 0  2
 0  4
```
