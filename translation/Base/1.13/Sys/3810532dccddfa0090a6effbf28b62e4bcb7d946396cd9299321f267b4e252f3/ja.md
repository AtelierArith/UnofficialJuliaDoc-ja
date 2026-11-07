```julia
Sys.isnetbsd([os])
```

OSがNetBSDの派生版かどうかを判定する述語です。詳しくは[Handling Operating System Variation](@ref)を参照してください。

!!! note
    `Sys.isbsd()`と混同しないでください。これはNetBSD上では`true`ですが、ほかのBSDベースのシステムでも同様です。`Sys.isnetbsd()`が指すのはNetBSDのみです。


!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。

