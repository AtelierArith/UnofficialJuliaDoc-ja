```
put!(f::Function, x::OrderedSynchronizer, i::Int, incr::Int=1)
```

`x`が順序`i`にあるときに`f`が呼び出されるようにスケジュールします。`put!`は`f`が実行されるまでブロックされることに注意してください。典型的な使用法は次のようになります：

```julia
x = OrderedSynchronizer()
@sync for i = 1:N
    Threads.@spawn begin
        # 一部の並行作業を行う
        # 作業が完了したら、同期をスケジュールする
        put!(x, $i) do
            # 並行作業の結果を報告する
            # `put!`へのすべての`i-1`の呼び出しが完了するまで実行されません
        end
    end
end
```

`incr`引数は、`f`が呼び出された後に同期装置の状態がどれだけ増加するかを制御します。デフォルトでは、`incr`は1です。
