```julia
Base.touch(::Pidfile.LockMonitor)
```

ロックの `mtime` を更新して、それがまだ新しいことを示します。

[`mkpidlock`](@ref) コンストラクタの `refresh` キーワードも参照してください。
