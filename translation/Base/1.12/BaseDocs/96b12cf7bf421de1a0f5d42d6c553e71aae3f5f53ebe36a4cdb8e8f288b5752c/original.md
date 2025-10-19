```julia
Array{T}(undef, dims)
Array{T,N}(undef, dims)
```

Construct an uninitialized `N`-dimensional [`Array`](@ref) containing elements of type `T`. `N` can either be supplied explicitly, as in `Array{T,N}(undef, dims)`, or be determined by the length or number of `dims`. `dims` may be a tuple or a series of integer arguments corresponding to the lengths in each dimension. If the rank `N` is supplied explicitly, then it must match the length or number of `dims`. Here [`undef`](@ref) is the [`UndefInitializer`](@ref).

# Examples

```julia-repl
julia> A = Array{Float64, 2}(undef, 2, 3) # N given explicitly
2×3 Matrix{Float64}:
 6.90198e-310  6.90198e-310  6.90198e-310
 6.90198e-310  6.90198e-310  0.0

julia> B = Array{Float64}(undef, 4) # N determined by the input
4-element Vector{Float64}:
   2.360075077e-314
 NaN
   2.2671131793e-314
   2.299821756e-314

julia> similar(B, 2, 4, 1) # use typeof(B), and the given size
2×4×1 Array{Float64, 3}:
[:, :, 1] =
 2.26703e-314  2.26708e-314  0.0           2.80997e-314
 0.0           2.26703e-314  2.26708e-314  0.0
```
