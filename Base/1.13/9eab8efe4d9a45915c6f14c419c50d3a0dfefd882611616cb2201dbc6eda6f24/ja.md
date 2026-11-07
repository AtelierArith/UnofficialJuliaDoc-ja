```julia
@time expr
@time "description" expr
```

式を実行し、その実行にかかった時間、割り当て回数、および実行によって割り当てられた総バイト数を表示してから、式の値を返すマクロです。ガベージコレクション（gc）、新しいコードのコンパイル、または無効化されたコードの再コンパイルにかかった時間は、割合として表示されます。[`ReentrantLock`](@ref)が待機する必要のあったロック競合は、件数で表示されます。

時間のレポートの前に表示する説明文字列を、任意で指定できます。

場合によっては、トップレベルの式の実行が始まる前に、システムが`@time`式の内部を調べ、呼び出されるコードの一部をコンパイルすることがあります。その場合、コンパイル時間の一部は計測されません。この時間も含めるには、`@time @eval ...`を実行してください。

関連項目：[`@showtime`](@ref)、[`@timev`](@ref)、[`@timed`](@ref)、[`@elapsed`](@ref)、[`@allocated`](@ref)、[`@allocations`](@ref)。

!!! note
    より本格的なベンチマークには、BenchmarkTools.jlパッケージの`@btime`マクロを検討してください。このマクロは、ノイズを抑えるために関数を複数回評価するなどの処理を行います。


!!! compat "Julia 1.8"
    説明を追加するオプションは、Julia 1.8で導入されました。

    再コンパイル時間をコンパイル時間とは別に表示する機能は、Julia 1.8で導入されました。


!!! compat "Julia 1.11"
    ロック競合の件数を報告する機能は、Julia 1.11で追加されました。


```julia-repl
julia> x = rand(10,10);

julia> @time x * x;
  0.606588 seconds (2.19 M allocations: 116.555 MiB, 3.75% gc time, 99.94% compilation time)

julia> @time x * x;
  0.000009 seconds (1 allocation: 896 bytes)

julia> @time begin
           sleep(0.3)
           1+1
       end
  0.301395 seconds (8 allocations: 336 bytes)
2

julia> @time "A one second sleep" sleep(1)
A one second sleep: 1.005750 seconds (5 allocations: 144 bytes)

julia> for loop in 1:3
            @time loop sleep(1)
        end
1: 1.006760 seconds (5 allocations: 144 bytes)
2: 1.001263 seconds (5 allocations: 144 bytes)
3: 1.003676 seconds (5 allocations: 144 bytes)
```
