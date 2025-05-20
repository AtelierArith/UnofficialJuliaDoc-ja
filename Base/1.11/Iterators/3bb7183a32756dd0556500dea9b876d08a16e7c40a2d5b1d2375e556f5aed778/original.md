```
take(iter, n)
```

An iterator that generates at most the first `n` elements of `iter`.

See also: [`drop`](@ref Iterators.drop), [`peel`](@ref Iterators.peel), [`first`](@ref), [`Base.take!`](@ref).

# Examples

```jldoctest
julia> a = 1:2:11
1:2:11

julia> collect(a)
6-element Vector{Int64}:
  1
  3
  5
  7
  9
 11

julia> collect(Iterators.take(a,3))
3-element Vector{Int64}:
 1
 3
 5
```
