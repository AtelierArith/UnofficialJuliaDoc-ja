```
Sys.isopenbsd([os])
```

OpenBSDの派生であるかどうかをテストするための述語。詳細は[Operating System Variationの取り扱い](@ref)を参照してください。

!!! note
    `Sys.isbsd()`と混同しないでください。これはOpenBSDでは`true`ですが、他のBSDベースのシステムでも`true`です。`Sys.isopenbsd()`はOpenBSDのみに関連しています。


!!! compat "Julia 1.1"
    この関数は少なくともJulia 1.1が必要です。

