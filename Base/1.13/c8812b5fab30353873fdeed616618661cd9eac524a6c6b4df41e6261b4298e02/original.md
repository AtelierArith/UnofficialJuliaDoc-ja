```julia
WeakRef(x)
```

`w = WeakRef(x)` constructs a [weak reference](https://en.wikipedia.org/wiki/Weak_reference) to the Julia value `x`: although `w` contains a reference to `x`, it does not prevent `x` from being garbage collected. `w.value` is either `x` (if `x` has not been garbage-collected yet) or `nothing` (if `x` has been garbage-collected).

```jldoctest
julia> x = "a string"
"a string"

julia> w = WeakRef(x)
WeakRef("a string")

julia> GC.gc()

julia> w           # a reference is maintained via `x`
WeakRef("a string")

julia> x = nothing # clear reference

julia> GC.gc()

julia> w
WeakRef(nothing)
```
