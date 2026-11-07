```julia
Sys.isdragonfly([os])
```

OSがDragonFly BSDの派生版かどうかを判定する述語です。[Handling Operating System Variation](@ref)のドキュメントを参照してください。

!!! note
    `Sys.isbsd()`と混同しないでください。これはDragonFlyだけでなく、ほかのBSD系システムでも`true`です。`Sys.isdragonfly()`が指すのはDragonFlyだけです。


!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。

