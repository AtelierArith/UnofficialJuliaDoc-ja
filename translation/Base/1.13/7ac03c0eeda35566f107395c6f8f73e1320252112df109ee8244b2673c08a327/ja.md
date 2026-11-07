```julia
acquire(f, s::Semaphore)
```

Semaphore から `s` を取得した後に `f` を実行し、完了時またはエラー発生時に `release` を実行します。

たとえば、同時にアクティブになる `foo` の呼び出しを 2 回までに制限する do-block 形式は次のとおりです。

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
    このメソッドを使用するには、Julia 1.8 以降が必要です。

