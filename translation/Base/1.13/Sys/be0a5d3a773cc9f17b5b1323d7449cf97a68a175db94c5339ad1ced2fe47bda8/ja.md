```julia
Sys.isfreebsd([os])
```

OS が FreeBSD の派生であるかどうかを判定する述語です。[Handling Operating System Variation](@ref) のドキュメントを参照してください。

!!! note
    `Sys.isbsd()` と混同しないでください。これは FreeBSD だけでなく、ほかの BSD ベースのシステムでも `true` になります。`Sys.isfreebsd()` は FreeBSD のみを指します。


!!! compat "Julia 1.1"
    この関数には Julia 1.1 以降が必要です。

