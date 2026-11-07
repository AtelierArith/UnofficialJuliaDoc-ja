```julia
Sys.isdragonfly([os])
```

OS が DragonFly BSD の派生であるかどうかを判定する述語です。[Handling Operating System Variation](@ref) のドキュメントを参照してください。

!!! note
    `Sys.isbsd()` と混同しないでください。これは DragonFly だけでなく、他の BSD ベースのシステムでも `true` になります。`Sys.isdragonfly()` は DragonFly のみを対象とします。


!!! compat "Julia 1.1"
    この関数には Julia 1.1 以降が必要です。

