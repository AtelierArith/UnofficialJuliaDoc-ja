```julia
Threads.Condition([lock])
```

[`Base.Condition`](@ref)のスレッドセーフなバージョンです。

`Threads.Condition`に対して[`wait`](@ref)または[`notify`](@ref)を呼び出すには、まず[`lock`](@ref)を呼び出す必要があります。`wait`を呼び出すと、ブロック中はロックがアトミックに解放され、`wait`が戻る前に再取得されます。そのため、`Threads.Condition` `c`の慣用的な使い方は次のようになります。

```julia
lock(c)
try
    while !thing_we_are_waiting_for
        wait(c)
    end
finally
    unlock(c)
end
```

!!! compat "Julia 1.2"
    この機能を使用するには、Julia 1.2以降が必要です。

