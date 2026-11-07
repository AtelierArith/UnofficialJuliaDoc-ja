```julia
systemsleep(s::Real)
```

`s` 秒間、実行を一時停止します。この関数は Julia のスケジューラに制御を譲らないため、スリープ中は実行中の Julia スレッドをブロックします。

[`sleep`](@ref) を参照してください。
