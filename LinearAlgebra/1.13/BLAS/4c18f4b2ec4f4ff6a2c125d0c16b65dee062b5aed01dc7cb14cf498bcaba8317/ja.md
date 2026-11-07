```julia
lbt_forwarded_funcs(config::LBTConfig, lib::LBTLibraryInfo)
```

バックエンドライブラリ `lib` を指定すると、そのライブラリに転送されるすべての関数を `String` のベクターとして返します。
