```
Threads.Condition([lock])
```

[`Base.Condition`](@ref) のスレッドセーフなバージョンです。

`Threads.Condition` で [`wait`](@ref) または [`notify`](@ref) を呼び出すには、まずそれに対して [`lock`](@ref) を呼び出す必要があります。`wait` が呼び出されると、ロックはブロッキング中に原子的に解放され、`wait` が戻る前に再取得されます。したがって、`Threads.Condition` `c` の慣用的な使用法は次のようになります。

```
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
    この機能は少なくとも Julia 1.2 が必要です。

