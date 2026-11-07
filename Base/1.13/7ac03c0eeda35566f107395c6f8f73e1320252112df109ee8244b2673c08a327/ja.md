```julia
acquire(f, s::Semaphore)
```

Semaphore `s`から取得した後に`f`を実行し、完了時またはエラー発生時に`release`を実行します。

たとえば、次のdoブロック形式では、`foo`の呼び出しが同時にアクティブになるのは2つまでです。

```julia
s = Base.Semaphore(2)
@sync for _ in 1:100
    Threads.@spawn begin
        Base.acquire(s) do
            foo()
        end
    end
end
```

!!! compat "Julia 1.8"
    このメソッドを使用するには、Julia 1.8以降が必要です。

