```julia
@timed
```

式を実行し、その式の値、経過時間（秒）、割り当てられた合計バイト数、ガベージコレクション時間、各種メモリ割り当てカウンターを含むオブジェクト、コンパイル時間（秒）、再コンパイル時間（秒）を返すマクロです。[`ReentrantLock`](@ref)が待機する必要のあったロック競合は、件数として表示されます。

場合によっては、トップレベルの式の実行が始まる前に、システムが`@timed`式の内部を調べ、呼び出されるコードの一部をコンパイルします。その場合、コンパイル時間の一部は計測されません。この時間も含めるには、`@timed @eval ...`を実行します。

[`@time`](@ref)、[`@timev`](@ref)、[`@elapsed`](@ref)、[`@allocated`](@ref)、[`@allocations`](@ref)、[`@lock_conflicts`](@ref)も参照してください。

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
    このマクロの戻り値の型は、Julia 1.5で`Tuple`から`NamedTuple`に変更されました。


!!! compat "Julia 1.11"
    `lock_conflicts`、`compile_time`、`recompile_time`フィールドがJulia 1.11で追加されました。

