```
@lock_conflicts
```

式を評価し、結果の値を破棄し、代わりに評価中のロック競合の総数を返すマクロです。ここで、[`ReentrantLock`](@ref) に対するロック試行が、ロックがすでに保持されているために待機を引き起こしました。

[`@time`](@ref)、[`@timev`](@ref)、および [`@timed`](@ref) も参照してください。

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
    このマクロは Julia 1.11 で追加されました。

