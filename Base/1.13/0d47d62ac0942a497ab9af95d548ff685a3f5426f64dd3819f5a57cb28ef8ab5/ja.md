```julia
@lock_conflicts
```

式を評価してその結果を破棄し、代わりに評価中に発生したロック競合の総数を返すマクロです。ロックがすでに保持されていたため、[`ReentrantLock`](@ref)へのロック取得が待機状態になった場合に、ロック競合として数えます。

[`@time`](@ref)、[`@timev`](@ref)、[`@timed`](@ref)も参照してください。

```julia-repl
julia> @lock_conflicts begin
    l = ReentrantLock()
    Threads.@threads for i in 1:Threads.nthreads()
        lock(l) do
        sleep(1)
        end
    end
end
5
```

!!! compat "Julia 1.11"
    このマクロはJulia 1.11で追加されました。

