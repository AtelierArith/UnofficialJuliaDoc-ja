```
@showtime expr
```

`@time`と似ていますが、参照のために評価されている式も印刷します。

!!! compat "Julia 1.8"
    このマクロはJulia 1.8で追加されました。


関連情報として[`@time`](@ref)を参照してください。

```julia-repl
julia> @showtime sleep(1)
sleep(1): 1.002164秒 (4回のアロケーション: 128バイト)
```
