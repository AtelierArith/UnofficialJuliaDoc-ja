```julia
info::ModifyOpInfo <: CallInfo
```

Represents a resolved call of one of:

  * `modifyfield!(obj, name, op, x, [order])`
  * `modifyglobal!(mod, var, op, x, order)`
  * `memoryrefmodify!(memref, op, x, order, boundscheck)`
  * `Intrinsics.atomic_pointermodify(ptr, op, x, order)`

`info.info` wraps the call information of `op(getval(), x)`.
