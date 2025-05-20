```
Sys.isbsd([os])
```

OSがBSDの派生であるかどうかをテストするための述語。詳細は[Operating System Variationの取り扱い](@ref)を参照してください。

!!! note
    DarwinカーネルはBSDから派生しているため、macOSシステムでは`Sys.isbsd()`は`true`になります。述語からmacOSを除外するには、`Sys.isbsd() && !Sys.isapple()`を使用してください。

