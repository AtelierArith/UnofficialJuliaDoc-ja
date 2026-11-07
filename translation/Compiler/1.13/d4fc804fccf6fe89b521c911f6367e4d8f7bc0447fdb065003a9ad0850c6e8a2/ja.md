```julia
info::ModifyOpInfo <: CallInfo
```

次のいずれかの解決済み呼び出しを表します。

  * `modifyfield!(obj, name, op, x, [order])`
  * `modifyglobal!(mod, var, op, x, order)`
  * `memoryrefmodify!(memref, op, x, order, boundscheck)`
  * `Intrinsics.atomic_pointermodify(ptr, op, x, order)`

`info.info`は、`op(getval(), x)`の呼び出し情報をラップします。
