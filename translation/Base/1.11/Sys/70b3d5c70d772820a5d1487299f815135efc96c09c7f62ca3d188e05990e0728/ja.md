```
Sys.isnetbsd([os])
```

NetBSDの派生であるかどうかをテストするための述語。詳細は[Operating System Variationの取り扱い](@ref)を参照してください。

!!! note
    `Sys.isbsd()`と混同しないでください。これはNetBSDでは`true`ですが、他のBSDベースのシステムでも`true`です。`Sys.isnetbsd()`はNetBSDのみに関連しています。


!!! compat "Julia 1.1"
    この関数は少なくともJulia 1.1が必要です。

