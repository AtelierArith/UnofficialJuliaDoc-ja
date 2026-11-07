```julia
Sys.isopenbsd([os])
```

OSがOpenBSDの派生版かどうかを判定する述語です。詳細は[Handling Operating System Variation](@ref)を参照してください。

!!! note
    `Sys.isbsd()`と混同しないでください。これはOpenBSDだけでなく、ほかのBSD系システムでも`true`です。`Sys.isopenbsd()`が指すのはOpenBSDのみです。


!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。

