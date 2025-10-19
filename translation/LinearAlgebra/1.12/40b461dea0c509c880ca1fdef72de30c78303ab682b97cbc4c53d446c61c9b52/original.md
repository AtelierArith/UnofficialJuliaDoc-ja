```julia
(I::UniformScaling)(n::Integer)
```

Construct a `Diagonal` matrix from a `UniformScaling`.

!!! compat "Julia 1.2"
    This method is available as of Julia 1.2.


# Examples

```jldoctest
julia> I(3)
3×3 Diagonal{Bool, Vector{Bool}}:
 1  ⋅  ⋅
 ⋅  1  ⋅
 ⋅  ⋅  1

julia> (0.7*I)(3)
3×3 Diagonal{Float64, Vector{Float64}}:
 0.7   ⋅    ⋅
  ⋅   0.7   ⋅
  ⋅    ⋅   0.7
```
