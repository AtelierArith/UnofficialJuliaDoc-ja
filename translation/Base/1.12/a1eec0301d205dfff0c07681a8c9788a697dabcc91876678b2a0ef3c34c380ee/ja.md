```julia
@timev expr
@timev "description" expr
```

これは`@time`マクロの詳細なバージョンです。最初に`@time`と同じ情報を印刷し、その後に非ゼロのメモリ割り当てカウンタを表示し、最後に式の値を返します。

オプションで、時間レポートの前に印刷する説明文字列を提供できます。

!!! compat "Julia 1.8"
    説明を追加するオプションはJulia 1.8で導入されました。


他に[`@time`](@ref)、[`@timed`](@ref)、[`@elapsed`](@ref)、[`@allocated`](@ref)、および[`@allocations`](@ref)を参照してください。

```julia-repl
julia> x = rand(10,10);

julia> @timev x * x;
  0.546770 seconds (2.20 M allocations: 116.632 MiB, 4.23% gc time, 99.94% compilation time)
elapsed time (ns): 546769547
gc time (ns):      23115606
bytes allocated:   122297811
pool allocs:       2197930
non-pool GC allocs:1327
malloc() calls:    36
realloc() calls:   5
GC pauses:         3

julia> @timev x * x;
  0.000010 seconds (1 allocation: 896 bytes)
elapsed time (ns): 9848
bytes allocated:   896
pool allocs:       1
```
