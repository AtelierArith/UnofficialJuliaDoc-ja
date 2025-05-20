```
Sys.isdragonfly([os])
```

DragonFly BSDの派生であるかどうかをテストするための述語。詳細は[Operating System Variationの取り扱い](@ref)を参照してください。

!!! note
    `Sys.isbsd()`と混同しないでください。これはDragonFlyでは`true`ですが、他のBSDベースのシステムでも`true`です。`Sys.isdragonfly()`はDragonFlyのみに関連しています。


!!! compat "Julia 1.1"
    この関数は少なくともJulia 1.1が必要です。

