```
@timed
```

式を実行し、その式の値、経過時間（秒）、合計バイト数、ガベージコレクション時間、さまざまなメモリアロケーションカウンタを持つオブジェクト、コンパイル時間（秒）、および再コンパイル時間（秒）を返すマクロです。 [`ReentrantLock`](@ref) が待機しなければならなかったロックの競合は、カウントとして表示されます。

場合によっては、システムは `@timed` 式の内部を調べ、トップレベルの式の実行が始まる前に呼び出されたコードの一部をコンパイルします。その場合、一部のコンパイル時間はカウントされません。この時間を含めるには、`@timed @eval ...` を実行できます。

他に [`@time`](@ref)、[`@timev`](@ref)、[`@elapsed`](@ref)、[`@allocated`](@ref)、[`@allocations`](@ref)、および [`@lock_conflicts`](@ref) も参照してください。

```julia-repl
julia> stats = @timed rand(10^6);

julia> stats.time
0.006634834

julia> stats.bytes
8000256

julia> stats.gctime
0.0055765

julia> propertynames(stats.gcstats)
(:allocd, :malloc, :realloc, :poolalloc, :bigalloc, :freecall, :total_time, :pause, :full_sweep)

julia> stats.gcstats.total_time
5576500

julia> stats.compile_time
0.0

julia> stats.recompile_time
0.0

```

!!! compat "Julia 1.5"
    このマクロの戻り値の型は、Julia 1.5で `Tuple` から `NamedTuple` に変更されました。


!!! compat "Julia 1.11"
    `lock_conflicts`、`compile_time`、および `recompile_time` フィールドは、Julia 1.11で追加されました。

