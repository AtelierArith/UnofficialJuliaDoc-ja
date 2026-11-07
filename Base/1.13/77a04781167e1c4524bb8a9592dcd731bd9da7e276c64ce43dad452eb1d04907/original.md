```julia
Set{T} <: AbstractSet{T}
```

`Set`s are mutable containers that provide fast membership testing.

`Set`s have efficient implementations of set operations such as `in`, `union` and `intersect`. Elements in a `Set` are unique, as determined by the elements' definition of `isequal`. The order of elements in a `Set` is an implementation detail and cannot be relied on.

See also: [`AbstractSet`](@ref), [`BitSet`](@ref), [`Dict`](@ref), [`push!`](@ref), [`empty!`](@ref), [`union!`](@ref), [`in`](@ref), [`isequal`](@ref)

# Examples

```jldoctest; filter = r"^  '.'"ma
julia> s = Set("aaBca")
Set{Char} with 3 elements:
  'a'
  'c'
  'B'

julia> push!(s, 'b')
Set{Char} with 4 elements:
  'a'
  'b'
  'B'
  'c'

julia> s = Set([NaN, 0.0, 1.0, 2.0]);

julia> -0.0 in s # isequal(0.0, -0.0) is false
false

julia> NaN in s # isequal(NaN, NaN) is true
true
```
