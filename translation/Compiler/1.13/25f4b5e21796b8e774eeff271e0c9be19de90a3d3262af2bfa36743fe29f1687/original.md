```julia
alias::MustAlias
```

This lattice element wraps a reference to object field while recoding the identity of the parent object. It allows certain constraints that can be imposed on the object field type by built-in functions like `isa` and `===` to be propagated to another reference to the same object field. One important note is that this lattice element assumes the invariant that the field of wrapped slot object never changes until the slot object is re-assigned. This means, the wrapped object field should be constant as inference currently doesn't track any memory effects on per-object basis. Particularly `maybe_const_fldidx` takes the lift to check if a given lattice element is eligible to be wrapped by `MustAlias`. Example:

```juila
let alias = getfield(x::Some{Union{Nothing,String}}, :value)::MustAlias(x, Some{Union{Nothing,String}}, 1, Union{Nothing,String})
    if alias === nothing
        # May assume `getfield(x, :value)` is `nothing` now
    else
        # May assume `getfield(x, :value)` is `::String` now
    end
end
```

N.B. currently this lattice element is only used in abstractinterpret, not in optimization
