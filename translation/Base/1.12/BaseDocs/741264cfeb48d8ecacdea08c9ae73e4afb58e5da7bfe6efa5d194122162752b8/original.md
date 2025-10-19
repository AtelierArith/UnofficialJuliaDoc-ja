```julia
setfieldonce!(value, name::Union{Int,Symbol}, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> success::Bool
```

Atomically perform the operations to set a field to a given value, only if it was previously not set.

```julia
ok = !isdefined(value, name, fail_order)
if ok
    setfield!(value, name, desired, success_order)
end
return ok
```

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.

