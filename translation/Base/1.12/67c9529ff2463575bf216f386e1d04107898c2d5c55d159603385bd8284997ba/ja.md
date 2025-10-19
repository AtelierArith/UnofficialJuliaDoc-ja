```julia
acquire(f, s::Semaphore)
```

Semaphore `s` から取得した後に `f` を実行し、完了またはエラー時に `release` します。

例えば、同時に `foo` の呼び出しが2回だけアクティブであることを保証する do-block 形式の例：

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
    このメソッドは少なくとも Julia 1.8 を必要とします。

