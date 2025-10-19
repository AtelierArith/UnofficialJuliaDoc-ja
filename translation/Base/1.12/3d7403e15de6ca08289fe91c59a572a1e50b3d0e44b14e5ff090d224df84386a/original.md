```julia
in!(x, s::AbstractSet) -> Bool
```

If `x` is in `s`, return `true`. If not, push `x` into `s` and return `false`. This is equivalent to `in(x, s) ? true : (push!(s, x); false)`, but may have a more efficient implementation.

See also: [`in`](@ref), [`push!`](@ref), [`Set`](@ref)

!!! compat "Julia 1.11"
    This function requires at least 1.11.


# Examples

```jldoctest; filter = r"^  [1234]$"
julia> s = Set{Any}([1, 2, 3]); in!(4, s)
false

julia> length(s)
4

julia> in!(0x04, s)
true

julia> s
Set{Any} with 4 elements:
  4
  2
  3
  1
```
