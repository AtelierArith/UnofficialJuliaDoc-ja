```
rand([rng=default_rng()], [S], [dims...])
```

Pick a random element or array of random elements from the set of values specified by `S`; `S` can be

  * an indexable collection (for example `1:9` or `('x', "y", :z)`)
  * an `AbstractDict` or `AbstractSet` object
  * a string (considered as a collection of characters), or
  * a type from the list below, corresponding to the specified set of values

      * concrete integer types sample from `typemin(S):typemax(S)` (excepting [`BigInt`](@ref) which is not supported)
      * concrete floating point types sample from `[0, 1)`
      * concrete complex types `Complex{T}` if `T` is a sampleable type take their real and imaginary components independently from the set of values corresponding to `T`, but are not supported if `T` is not sampleable.
      * all `<:AbstractChar` types sample from the set of valid Unicode scalars
      * a user-defined type and set of values; for implementation guidance please see [Hooking into the `Random` API](@ref rand-api-hook)
      * a tuple type of known size and where each parameter of `S` is itself a sampleable type; return a value of type `S`. Note that tuple types such as `Tuple{Vararg{T}}` (unknown size) and `Tuple{1:2}` (parameterized with a value) are not supported
      * a `Pair` type, e.g. `Pair{X, Y}` such that `rand` is defined for `X` and `Y`, in which case random pairs are produced.

`S` defaults to [`Float64`](@ref). When only one argument is passed besides the optional `rng` and is a `Tuple`, it is interpreted as a collection of values (`S`) and not as `dims`.

See also [`randn`](@ref) for normally distributed numbers, and [`rand!`](@ref) and [`randn!`](@ref) for the in-place equivalents.

!!! compat "Julia 1.1"
    Support for `S` as a tuple requires at least Julia 1.1.


!!! compat "Julia 1.11"
    Support for `S` as a `Tuple` type requires at least Julia 1.11.


# Examples

```julia-repl
julia> rand(Int, 2)
2-element Array{Int64,1}:
 1339893410598768192
 1575814717733606317

julia> using Random

julia> rand(Xoshiro(0), Dict(1=>2, 3=>4))
3 => 4

julia> rand((2, 3))
3

julia> rand(Float64, (2, 3))
2×3 Array{Float64,2}:
 0.999717  0.0143835  0.540787
 0.696556  0.783855   0.938235
```

!!! note
    The complexity of `rand(rng, s::Union{AbstractDict,AbstractSet})` is linear in the length of `s`, unless an optimized method with constant complexity is available, which is the case for `Dict`, `Set` and dense `BitSet`s. For more than a few calls, use `rand(rng, collect(s))` instead, or either `rand(rng, Dict(s))` or `rand(rng, Set(s))` as appropriate.

