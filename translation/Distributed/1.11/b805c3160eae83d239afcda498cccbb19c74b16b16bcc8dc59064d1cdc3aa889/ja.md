```julia
capture_exception(ex::RemoteException, bt)
```

バックトレースをすでに取得済みの `ex::RemoteException` を返します（[`CapturedException`](@ref) フィールド `captured` を介して取得）。
