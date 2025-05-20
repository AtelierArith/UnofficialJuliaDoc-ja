```
Threads.threadid() -> Int
```

現在の実行スレッドのID番号を取得します。マスタースレッドのIDは `1` です。

# 例

```julia-repl
julia> Threads.threadid()
1

julia> Threads.@threads for i in 1:4
          println(Threads.threadid())
       end
4
2
5
4
```

!!! 注     タスクが実行されるスレッドは、タスクがYieldすると変更される可能性があり、これを [`Task Migration`](@ref man-task-migration) と呼びます。このため、ほとんどの場合、`threadid()` を使用してバッファや状態を持つオブジェクトのベクターにインデックスを付けることは安全ではありません。
