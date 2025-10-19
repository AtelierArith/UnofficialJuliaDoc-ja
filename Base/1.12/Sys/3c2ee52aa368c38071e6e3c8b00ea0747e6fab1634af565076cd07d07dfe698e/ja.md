```julia
Sys.isopenbsd([os])
```

OpenBSDの派生であるかどうかをテストするための述語。詳細は[Handling Operating System Variation](@ref)のドキュメントを参照してください。

!!! note
    `Sys.isbsd()`と混同しないでください。これはOpenBSDだけでなく、他のBSDベースのシステムでも`true`になります。`Sys.isopenbsd()`はOpenBSDのみに関連しています。


!!! compat "Julia 1.1"
    この関数は少なくともJulia 1.1が必要です。

