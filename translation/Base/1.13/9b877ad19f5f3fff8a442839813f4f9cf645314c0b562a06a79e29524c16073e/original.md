```julia
Base.summarysize(obj; count = false, exclude=Union{...}, chargeall=Union{...})::Int
```

Compute all unique objects reachable from the argument and return either their size in memory (in bytes) or the number of allocations they span.

# Keyword Arguments

  * `count`: if false, return the total size of the objects in memory. if true, return the number of allocations spanned by the object.
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

julia> Base.summarysize(Core.svec(1.0, "testing", true); count=true)
4
```
