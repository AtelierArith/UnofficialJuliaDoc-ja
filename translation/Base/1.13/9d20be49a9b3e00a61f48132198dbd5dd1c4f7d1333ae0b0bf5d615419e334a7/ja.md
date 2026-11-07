```julia
@timev expr
@timev "description" expr
```

これは、`@time` マクロの詳細版です。まず `@time` と同じ情報を出力し、続いてゼロ以外のメモリ割り当てカウンターを出力した後、式の値を返します。

必要に応じて、時間レポートの前に出力する説明文字列を指定できます。

!!! compat "Julia 1.8"
    説明を追加するオプションは Julia 1.8 で導入されました。


関連項目: [`@time`](@ref)、[`@timed`](@ref)、[`@elapsed`](@ref)、[`@allocated`](@ref)、[`@allocations`](@ref)。

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
