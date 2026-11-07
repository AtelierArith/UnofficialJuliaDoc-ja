```julia
Base.touch(::Pidfile.LockMonitor)
```

ロックの`mtime`を更新して、まだ新しいことを示します。

[`mkpidlock`](@ref)コンストラクターの`refresh`キーワードも参照してください。
