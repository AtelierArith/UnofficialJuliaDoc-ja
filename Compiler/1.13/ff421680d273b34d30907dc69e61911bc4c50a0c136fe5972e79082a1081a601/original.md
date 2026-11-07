```julia
cnd::Conditional
```

The type of this value might be `Bool`. However, to enable a limited amount of back-propagation, we also keep some information about how this `Bool` value was created. In particular, if you branch on this value, then may assume that in the true branch, the type of `SlotNumber(cnd.slot)` will be limited by `cnd.thentype` and in the false branch, it will be limited by `cnd.elsetype`. Example:

```julia
let cond = isa(x::Union{Int, Float}, Int)::Conditional(x, Int, Float)
    if cond
       # May assume x is `Int` now
    else
       # May assume x is `Float` now
    end
end
```
