```julia
log(x)
```

Compute the natural logarithm of `x`.

Throw a [`DomainError`](@ref) for negative [`Real`](@ref) arguments. Use [`Complex`](@ref) arguments to obtain [`Complex`](@ref) results.

!!! note "Branch cut"
    `log` has a branch cut along the negative real axis; `-0.0im` is taken to be below the axis.


See also [`ℯ`](@ref), [`log1p`](@ref), [`log2`](@ref), [`log10`](@ref).

# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> log(2)
0.6931471805599453

julia> log(-3)
ERROR: DomainError with -3.0:
log was called with a negative real argument but will only return a complex result if called with a complex argument. Try log(Complex(x)).
Stacktrace:
 [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
[...]

julia> log(-3 + 0im)
1.0986122886681098 + 3.141592653589793im

julia> log(-3 - 0.0im)
1.0986122886681098 - 3.141592653589793im

julia> log.(exp.(-1:1))
3-element Vector{Float64}:
 -1.0
  0.0
  1.0
```
