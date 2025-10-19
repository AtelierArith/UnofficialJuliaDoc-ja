```julia
Timer(delay; interval = 0)
```

タイマーを作成し、タスクがそれを待機している場合（タイマーオブジェクトで[`wait`](@ref)を呼び出すことによって）起こします。

待機中のタスクは、最初の遅延が少なくとも`delay`秒経過した後に起こされ、その後は少なくとも`interval`秒が経過するごとに繰り返し起こされます。`interval`が`0`に等しい場合、タイマーは一度だけトリガーされます。タイマーが閉じられると（[`close`](@ref)によって）待機中のタスクはエラーで起こされます。タイマーがまだアクティブかどうかを確認するには[`isopen`](@ref)を使用します。`t.timeout`および`t.interval`を使用して、`Timer` `t`の設定条件を読み取ります。

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
    `interval`は時間のずれを蓄積する影響を受けます。特定の絶対時間で正確なイベントが必要な場合は、次の時間までの差を計算して、各満了時に新しいタイマーを作成してください。


!!! note
    `Timer`はその状態を更新するためにイールドポイントを必要とします。たとえば、`isopen(t::Timer)`は、イールドしないwhileループのタイムアウトには使用できません。


!!! compat "Julia 1.12     `timeout`および`interval`の読み取り可能なプロパティはJulia 1.12で追加されました。
