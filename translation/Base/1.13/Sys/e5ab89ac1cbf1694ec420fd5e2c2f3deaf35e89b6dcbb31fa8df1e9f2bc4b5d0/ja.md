```julia
Sys.isbsd([os])
```

OSがBSDの派生かどうかを判定する述語です。詳しくは[Handling Operating System Variation](@ref)を参照してください。

!!! note
    DarwinカーネルはBSDを起源としているため、macOSでは`Sys.isbsd()`は`true`になります。述語の対象からmacOSを除外するには、`Sys.isbsd() && !Sys.isapple()`を使用してください。

