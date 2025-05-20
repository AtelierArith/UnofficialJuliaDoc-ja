```
Sys.isfreebsd([os])
```

FreeBSDの派生であるかどうかをテストするための述語です。詳細は[Operating System Variationの取り扱い](@ref)を参照してください。

!!! note
    `Sys.isbsd()`と混同しないでください。これはFreeBSDでは`true`ですが、他のBSDベースのシステムでも`true`です。`Sys.isfreebsd()`はFreeBSDのみに関連しています。


!!! compat "Julia 1.1"
    この関数は少なくともJulia 1.1が必要です。

