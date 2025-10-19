```julia
Base.summarysize(obj; exclude=Union{...}, chargeall=Union{...}) -> Int
```

Compute the amount of memory, in bytes, used by all unique objects reachable from the argument.

# Keyword Arguments

  * `exclude`: specifies the types of objects to exclude from the traversal.
  * `chargeall`: specifies the types of objects to always charge the size of all of their fields, even if those fields would normally be excluded.

See also [`sizeof`](@ref).

# Examples

```jldoctest
julia> Base.summarysize(1.0)
8

julia> Base.summarysize(Ref(rand(100)))
848

julia> sizeof(Ref(rand(100)))
8
```
