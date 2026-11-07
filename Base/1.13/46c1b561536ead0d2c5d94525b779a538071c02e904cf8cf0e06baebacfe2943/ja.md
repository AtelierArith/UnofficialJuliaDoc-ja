```julia
@showtime expr
```

`@time`と似ていますが、参照用に評価対象の式も出力します。

!!! compat "Julia 1.8"
    このマクロはJulia 1.8で追加されました。


関連項目: [`@time`](@ref)。

```julia-repl
julia> @showtime sleep(1)
sleep(1): 1.002164 seconds (4 allocations: 128 bytes)
```
