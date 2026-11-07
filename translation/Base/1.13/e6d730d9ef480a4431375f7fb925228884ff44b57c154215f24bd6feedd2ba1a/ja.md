```julia
Timer(delay; interval = 0)
```

タイマーを作成すると、タイマーオブジェクトに対して [`wait`](@ref) を呼び出すことで、タイマーを待っているタスクを起こせます。

待機中のタスクは、最初の遅延時間として少なくとも `delay` 秒が経過した後に起こされます。その後は、さらに少なくとも `interval` 秒が経過するたびに起こされます。`interval` が `0` と等しい場合、タイマーは一度だけ起動します。タイマーを閉じる（[`close`](@ref) を呼び出す）と、待機中のタスクはエラーによって起こされます。タイマーがまだアクティブかどうかを確認するには、[`isopen`](@ref) を使用します。非アクティブなタイマーは起動しません。`t.timeout` と `t.interval` を使うと、`Timer` `t` の設定条件を読み取れます。

```julia-repl
julia> t = Timer(1.0; interval=0.5)
Timer (open, timeout: 1.0 s, interval: 0.5 s) @0x000000010f4e6e90

julia> isopen(t)
true

julia> t.timeout
1.0

julia> close(t)

julia> isopen(t)
false
```

!!! note
    `interval` では、時間のずれが累積する可能性があります。特定の絶対時刻に正確なイベントを発生させる必要がある場合は、各回の期限が来るたびに新しいタイマーを作成し、次の時刻までの差分を計算してください。


!!! note
    `Timer` の状態を更新するには、yield ポイントが必要です。たとえば、yield しない while ループのタイムアウトに `isopen(t::Timer)` を使用することはできません。


!!! compat "Julia 1.12     `timeout` と `interval` の読み取り可能なプロパティは、Julia 1.12 で追加されました。
