```julia
isTypeDataType(@nospecialize t)::Bool
```

型 `t` について、`isa(S, rewrap_unionall(Type{t}, ...))` を満たすすべての S に対して、`isa(S, DataType)` が成り立つかを確認します。特に、ある文が `Type{t}` として型付けされている場合（何らかの `UnionAll` でラップされている可能性もあります）、実行時にはその文が必ず `DataType` になることが保証されます（たとえば、それと typeequal な `Union` や `UnionAll` 型にはなりません）。
