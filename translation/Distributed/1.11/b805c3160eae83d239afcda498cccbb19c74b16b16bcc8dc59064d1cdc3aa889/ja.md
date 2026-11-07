```julia
capture_exception(ex::RemoteException, bt)
```

バックトレースがすでに取得されている `ex::RemoteException` を返します（[`CapturedException`](@ref) フィールド `captured` を介して取得）。
