```julia
lbt_forwarded_funcs(config::LBTConfig, lib::LBTLibraryInfo)
```

バックエンドライブラリ `lib` が与えられたとき、そのライブラリに転送されるすべての関数を、`String` のベクターとして返します。
