```julia
systemsleep(s::Real)
```

`s` 秒間、実行を一時停止します。この関数は Julia のスケジューラに制御を譲らないため、指定した時間のあいだ、実行中の Julia スレッドをブロックします。

関連項目: [`sleep`](@ref)。
